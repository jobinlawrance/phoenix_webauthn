defmodule PhoenixWebauthnWeb.UserSessionController do
  use PhoenixWebauthnWeb, :controller
  import Bitwise, only: [&&&: 2]

  alias PhoenixWebauthn.Accounts
  alias PhoenixWebauthnWeb.UserAuth

  def new(conn, _params) do
    conn
    |> put_webauthn_challenge()
    |> render(:new, error_message: nil)
  end

  def create(conn, params) do
    id = params |> Map.get("raw_id") |> Base.decode64!()
    authenticator_data = params |> Map.get("authenticator_data") |> Base.decode64!()
    client_data_json_str = params |> Map.get("client_data_json")
    signature = params |> Map.get("signature") |> Base.decode64!()

    with credential when not is_nil(credential) <- Accounts.get_credential(id),
         # Verify that the authenticator data and client data JSON are signed with the user's key.
         true <-
           verify_signature(credential, client_data_json_str, authenticator_data, signature),
         # Decode the client data JSON.
         {:ok, client_data_json} <- Jason.decode(client_data_json_str),
         # Make sure the values in the client data JSON are what we expect, and extract the challenge.
         {:ok, challenge} <- check_client_data_json(client_data_json),
         # Make sure the challenge singed by the user's key is what we generated.
         true <- challenge == get_session(conn, :webauthn_challenge),
         # Make sure the signed origin matches what we expect.
         true <- :binary.part(authenticator_data, 0, 32) == :crypto.hash(:sha256, "localhost"),
         # Check the user presence bit is set.
         true <- (:binary.at(authenticator_data, 32) &&& 1) == 1 do
      conn
      |> delete_session(:webauthn_challenge)
      |> UserAuth.log_in_user_without_redirect(credential.user)
      |> json(%{status: :ok})
    else
      _ ->
        json(conn, %{status: :error})
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end

  # def credentials(conn, %{"email" => email}) do
  #   ids =
  #     Accounts.get_credentials_by_email(email)

  #   # |> Enum.map(fn cred -> Base.encode64(cred.id) end)

  #   json(conn, ids)
  # end

  # Generate a value that will be signed by WebAuthn on the client.
  defp put_webauthn_challenge(conn) do
    # The challenge is returned by the browser in base 64 URL encoding, so match that.
    challenge = :crypto.strong_rand_bytes(64) |> Base.url_encode64(padding: false)

    conn
    |> put_session(:webauthn_challenge, challenge)
    |> assign(:webauthn_challenge, challenge)
  end

  defp verify_signature(credential, client_data_json_str, authenticator_data, signature) do
    with {:ok, pubkey} <- X509.PublicKey.from_der(credential.public_key_spki),
         client_data_json_hash <- :crypto.hash(:sha256, client_data_json_str),
         signed_message <- authenticator_data <> client_data_json_hash,
         true <- :public_key.verify(signed_message, :sha256, signature, pubkey) do
      true
    else
      _ ->
        false
    end
  end

  # If crossOrigin is present and is not false, we reject the login attempt.
  defp check_client_data_json(%{"crossOrigin" => crossOrigin}) when crossOrigin != false do
    false
  end

  defp check_client_data_json(%{
         "type" => "webauthn.get",
         "challenge" => challenge,
         "origin" => "http://localhost:4000"
       }) do
    {:ok, challenge}
  end

  defp check_client_data_json(_), do: false
end
