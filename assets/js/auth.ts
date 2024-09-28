import {
  base64URLStringToBuffer,
  browserSupportsWebAuthn,
  bufferToBase64URLString,
  startAuthentication,
  startRegistration,
} from "@simplewebauthn/browser";
import {
  generateAuthenticationOptions,
  GenerateAuthenticationOptionsOpts,
  generateRegistrationOptions,
  VerifiedAuthenticationResponse,
  verifyAuthenticationResponse,
  VerifyAuthenticationResponseOpts,
  verifyRegistrationResponse,
} from "@simplewebauthn/server";
import {
  AuthenticatorDevice,
  AuthenticatorTransportFuture,
  Base64URLString,
} from "@simplewebauthn/server/script/deps";
import { PublicKeyCredentialCreationOptionsJSON } from "@simplewebauthn/types";
import axios from "axios";

const rpID = "localhost";

document.addEventListener("DOMContentLoaded", () => {
  const registrationForm = document.forms.namedItem("registration-form");

  if (registrationForm) {
    const registerButton = registrationForm.querySelector(
      'button[type="submit"][phx-click="register"]',
    );
    const signInButton = registrationForm.querySelector(
      'button[type="submit"][phx-click="sign_in"]',
    );

    registerButton!!.addEventListener("click", (event) => {
      event.preventDefault();
      registerWebAuthnAccount(registrationForm);
    });

    signInButton!!.addEventListener("click", (event) => {
      event.preventDefault();
      loginWebAuthnAccount(registrationForm, false);
    });
  }
});

async function registerWebAuthnAccount(form: HTMLFormElement) {
  console.log("We are here 1");
  if (!browserSupportsWebAuthn()) {
    return;
  }

  console.log("We are here");

  let options;
  let attResp;
  try {
    options = await getUserOptions(form);
    attResp = await startRegistration(options);
  } catch (error) {
    // Some basic error handling
    console.log(error);
    throw error;
  }
  let verification;
  try {
    verification = await verifyRegistrationResponse({
      response: attResp,
      expectedChallenge: options.challenge,
      expectedOrigin: origin,
      expectedRPID: options.rp.id,
      requireUserVerification: false,
    });
  } catch (error) {
    console.error(error);
    throw error;
  }

  const { verified, registrationInfo } = verification;

  if (verified && registrationInfo) {
    // These are the values you're interested in:
    const { credentialID, credentialPublicKey, counter } = registrationInfo;

    const credentialPublicKeyBase64 =
      bufferToBase64URLString(credentialPublicKey);
    const newDevice = {
      credentialPublicKeyBase64,
      credentialID,
      counter,
      transports: attResp.response.transports,
    };

    const formData = new FormData();
    formData.append("_csrf_token", form._csrf_token.value);
    formData.append("email", form["email"].value);
    formData.append("credential_id", credentialID);
    formData.append(
      "public_key_spki",
      bufferToBase64URLString(credentialPublicKey),
    );
    formData.append("device", JSON.stringify(newDevice));

    const response = await axios.post(form.action, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    if (response.data.status === "ok") {
      // Registration successful, redirect to homepage
      window.location.href = "/";
    } else {
      console.error(response.data);
      alert("Registration failed");
    }
  }
}

async function getUserOptions(
  form: HTMLFormElement,
): Promise<PublicKeyCredentialCreationOptionsJSON> {
  return generateRegistrationOptions({
    rpID,
    rpName: "Phoenix Passkeys",
    userName: form["email"].value as string,
    // Don't prompt users for additional information about the authenticator
    // (Recommended for smoother UX)
    attestationType: "none",
    authenticatorSelection: {
      // Defaults
      residentKey: "preferred",
      userVerification: "preferred",
      // Optional
      authenticatorAttachment: "platform",
    },
  });
}

async function loginWebAuthnAccount(form: HTMLFormElement, condition: Boolean) {
  if (!browserSupportsWebAuthn()) {
    return;
  }

  const formData = new FormData();
  formData.append("_csrf_token", form._csrf_token.value);
  formData.append("email", form["email"].value);

  const csrfToken = form._csrf_token.value;

  const response = await axios.post<CredentialsResponse>(
    "/users/log_in/credentials",
    formData,
    {
      headers: {
        "Content-Type": "multipart/form-data",
        "X-CSRF-Token": csrfToken,
      },
    },
  );

  console.log(response.data);

  const device = response.data.credentials[0].device;
  const credential = {
    ...response.data.credentials[0],
    device: {
      ...device,
      credentialPublicKey: base64URLStringToUint8Array(
        device.credential_public_key,
      ),
    },
  };

  const opts: GenerateAuthenticationOptionsOpts = {
    timeout: 60000,
    allowCredentials: response.data.credentials.map((dev) => ({
      id: credential.credential_id,
      type: "public-key",
      transports: dev.device.transports,
    })),
    /**
     * Wondering why user verification isn't required? See here:
     *
     * https://passkeys.dev/docs/use-cases/bootstrapping/#a-note-about-user-verification
     */
    userVerification: "preferred",
    rpID,
  };

  console.log(JSON.stringify(opts, null, 2));
  const options = await generateAuthenticationOptions(opts);

  let asseResp;
  try {
    // Pass the options to the authenticator and wait for a response
    asseResp = await startAuthentication(options);
  } catch (error) {
    // Some basic error handling
    throw error;
  }

  let dbAuthenticator;
  if (credential.credential_id === asseResp.id) {
    dbAuthenticator = credential;
  }

  if (!dbAuthenticator) {
    throw Error("Authenticator is not registered with this site");
  }

  let verification: VerifiedAuthenticationResponse;
  try {
    const opts: VerifyAuthenticationResponseOpts = {
      response: asseResp,
      expectedChallenge: options.challenge,
      expectedOrigin: "http://localhost:4000",
      expectedRPID: rpID,
      authenticator: credential.device,
      requireUserVerification: false,
    };
    console.log(bufferToBase64URLString(credential.device.credentialPublicKey));
    // console.log(opts);
    verification = await verifyAuthenticationResponse(opts);
  } catch (error) {
    const _error = error as Error;
    console.log(_error.message);
    throw error;
  }

  const { verified, authenticationInfo } = verification;

  if (verified) {
    // Update the authenticator's counter in the DB to the newest count in the authentication
    console.log("All good yo");
  }
}

interface Device {
  counter: number;
  credentialID: string;
  credential_public_key: Base64URLString;
  transports: AuthenticatorTransportFuture[];
}

interface Credential {
  id: string;
  device: Device;
  inserted_at: string;
  updated_at: string;
  public_key_spki: string;
  credential_id: string;
}

interface CredentialsResponse {
  credentials: Credential[];
}

function base64URLStringToUint8Array(base64URLString: string) {
  if (typeof base64URLString !== "string") {
    throw new Error(
      `Expected a string, but received ${typeof base64URLString}`,
    );
  }
  const arrayBuffer = base64URLStringToBuffer(base64URLString);
  return new Uint8Array(arrayBuffer);
}
