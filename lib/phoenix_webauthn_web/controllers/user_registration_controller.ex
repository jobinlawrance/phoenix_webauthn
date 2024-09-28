defmodule PhoenixWebauthnWeb.UserRegistrationController do
  use PhoenixWebauthnWeb, :controller

  require Logger
  alias PhoenixWebauthn.Accounts
  alias PhoenixWebauthn.Accounts.User
  alias PhoenixWebauthnWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{
        "email" => email,
        "credential_id" => credential_id,
        "public_key_spki" => public_key_spki,
        "device" => device
      }) do
    credential_id = credential_id
    public_key_spki = public_key_spki

    case Accounts.register_user(email, credential_id, public_key_spki, device) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        conn
        |> UserAuth.log_in_user_without_redirect(user)
        |> json(%{status: :ok})

      {:error, _changeset} ->
        json(conn, %{status: :error})
    end
  end

  def verify_registration(conn, %{"attestation_object" => att_obj, "client_data" => client_data}) do
  end

  def credentials(conn, %{"email" => email}) do
    case Accounts.get_credentials_by_email(email) do
      credentials when is_list(credentials) ->
        encoded_credentials =
          Enum.map(credentials, fn cred ->
            %{
              id: cred.id,
              credential_id: cred.credential_id,
              public_key_spki: cred.public_key_spki,
              device: serialize_authenticator_device(cred.authenticator_device),
              inserted_at: NaiveDateTime.to_iso8601(cred.inserted_at),
              updated_at: NaiveDateTime.to_iso8601(cred.updated_at)
            }
          end)

        conn
        |> put_status(:ok)
        |> json(%{credentials: encoded_credentials})

      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "No credentials found for this email"})

      _ ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "An unexpected error occurred"})
    end
  end

  defp serialize_authenticator_device(device) do
    %{
      id: device.id,
      credential_public_key: Base.url_encode64(device.credential_public_key, padding: false),
      counter: device.counter,
      transports: device.transports,
      inserted_at: NaiveDateTime.to_iso8601(device.inserted_at),
      updated_at: NaiveDateTime.to_iso8601(device.updated_at)
    }
  end

  defp parse_json_field(nil), do: nil

  defp parse_json_field(json_string) when is_binary(json_string) do
    case Jason.decode(json_string) do
      {:ok, parsed_json} -> parsed_json
      # If it's not valid JSON, return the original string
      {:error, _} -> json_string
    end
  end

  # For any other type, return as is
  defp parse_json_field(value), do: value
end
