defmodule PhoenixWebauthnWeb.UserRegistrationController do
  use PhoenixWebauthnWeb, :controller

  alias PhoenixWebauthn.Accounts
  alias PhoenixWebauthn.Accounts.User
  alias PhoenixWebauthnWeb.UserAuth
  alias PhoenixWebauthnWeb.RegistrationVerifier

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{
        "email" => email,
        "credential_id" => credential_id,
        "public_key_spki" => public_key_spki
      }) do
    credential_id = credential_id
    public_key_spki = public_key_spki

    case Accounts.register_user(email, credential_id, public_key_spki) do
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
end
