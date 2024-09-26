defmodule PhoenixWebauthn.LoginFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PhoenixWebauthn.Login` context.
  """

  @doc """
  Generate a accounts.
  """
  def accounts_fixture(attrs \\ %{}) do
    {:ok, accounts} =
      attrs
      |> Enum.into(%{
        email: "some email"
      })
      |> PhoenixWebauthn.Login.create_accounts()

    accounts
  end
end
