import {
  browserSupportsWebAuthn,
  bufferToBase64URLString,
  startRegistration,
} from "@simplewebauthn/browser";
import {
  generateRegistrationOptions,
  verifyRegistrationResponse,
} from "@simplewebauthn/server";
import { AuthenticatorDevice } from "@simplewebauthn/server/script/deps";
import { PublicKeyCredentialCreationOptionsJSON } from "@simplewebauthn/types";

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
      loginWebAuthnAccount(registrationForm, false);
    });
  }
});

async function registerWebAuthnAccount(form: HTMLFormElement) {
  if (!browserSupportsWebAuthn()) {
    return;
  }

  const options = await getUserOptions(form);

  console.log("We are here");

  let attResp;
  try {
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

    const newDevice: AuthenticatorDevice = {
      credentialPublicKey,
      credentialID,
      counter,
      transports: attResp.response.transports,
    };

    const body = new FormData();
    body.append("_csrf_token", form._csrf_token.value);
    body.append("email", form["email"].value);
    body.append("credential_id", credentialID);
    body.append(
      "public_key_spki",
      bufferToBase64URLString(credentialPublicKey),
    );

    body.append("device", JSON.stringify(newDevice));

    const resp = await fetch(form.action, {
      method: "POST",
      body,
    });
    const respJSON = await resp.json();
    if (respJSON.status === "ok") {
      // Registration successful, redirect to homepage
      window.location.href = "/";
    } else {
      console.error(respJSON);
      alert("Registration failed");
      return;
    }
  }

  async function loginWebAuthnAccount(
    form: HTMLFormElement,
    condition: Boolean,
  ) {
    if (!browserSupportsWebAuthn()) {
      return;
    }
    //TODO
  }

  async function getUserOptions(
    form: HTMLFormElement,
  ): Promise<PublicKeyCredentialCreationOptionsJSON> {
    return generateRegistrationOptions({
      rpID: "localhost",
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

  function generateUserID() {
    const userID = new Uint8Array(64);
    crypto.getRandomValues(userID);
    return userID;
  }
}
