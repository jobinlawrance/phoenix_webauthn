import {
  browserSupportsWebAuthn,
  startRegistration,
} from "@simplewebauthn/browser";
import { verifyRegistrationResponse } from "@simplewebauthn/server";
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

  const options = getUserOptions(form);

  let attResp;
  try {
    attResp = await startRegistration(options);
  } catch (error) {
    // Some basic error handling
    throw error;
  }
  let verification;
  try {
    verification = await verifyRegistrationResponse({
      response: attResp,
      expectedChallenge: options.challenge,
      expectedOrigin: origin,
      expectedRPID: options.rp.id,
    });
  } catch (error) {
    console.error(error);
    throw error;
  }

  const { verified, registrationInfo } = verification;

  if (verified && registrationInfo) {
    // These are the values you're interested in:
    const {
      credentialID,
      credentialPublicKey,
      counter,
      credentialDeviceType,
      credentialBackedUp,
    } = registrationInfo;

    const body = new FormData();
    body.append("_csrf_token", form._csrf_token.value);
    body.append("email", form["email"].value);
    body.append("credential_id", credentialID);
    body.append("public_key_spki", arrayBufferToBase64(credentialPublicKey));

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

  function getUserOptions(
    form: HTMLFormElement,
  ): PublicKeyCredentialCreationOptionsJSON {
    const options: PublicKeyCredentialCreationOptionsJSON = {
      rp: {
        // In reality, this would be the actual app domain.
        id: "localhost",
        // User-facing name of the service.
        name: "Phoenix Passkeys",
      },
      user: {
        id: generateUserID().toString(),
        name: form["email"].value as string,
        displayName: "",
      },
      pubKeyCredParams: [
        {
          type: "public-key",
          // Ed25519
          alg: -8,
        },
        {
          type: "public-key",
          // ES256
          alg: -7,
        },
        {
          type: "public-key",
          // RS256
          alg: -257,
        },
      ],
      challenge: new Uint8Array(3).toString(),
      authenticatorSelection: {
        authenticatorAttachment: "cross-platform",
        // We want a discoverable credential, so that it's available when we request credentials for login.
        // Being discoverable is what means we don't require a separate username entry step.
        requireResidentKey: true,
      },
    };
    return options;
  }

  function generateUserID() {
    const userID = new Uint8Array(64);
    crypto.getRandomValues(userID);
    return userID;
  }
}
