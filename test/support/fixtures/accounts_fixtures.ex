defmodule PhoenixWebauthn.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixWebauthn.Accounts` context.
  """

  @doc """
  Generate a unique user email.
  """
  def unique_user_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        confirmed_at: ~N[2024-09-25 10:05:00],
        email: unique_user_email()
      })
      |> PhoenixWebauthn.Accounts.create_user()

    user
  end

  @doc """
  Generate a user_credential.
  """
  def user_credential_fixture(attrs \\ %{}) do
    {:ok, user_credential} =
      attrs
      |> Enum.into(%{
        public_key_spki: "some public_key_spki"
      })
      |> PhoenixWebauthn.Accounts.create_user_credential()

    user_credential
  end

  @doc """
  Generate a user_token.
  """
  def user_token_fixture(attrs \\ %{}) do
    {:ok, user_token} =
      attrs
      |> Enum.into(%{
        context: "some context",
        sent_to: "some sent_to",
        token: "some token"
      })
      |> PhoenixWebauthn.Accounts.create_user_token()

    user_token
  end
end
