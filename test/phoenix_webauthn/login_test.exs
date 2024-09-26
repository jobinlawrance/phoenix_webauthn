defmodule PhoenixWebauthn.LoginTest do
  use PhoenixWebauthn.DataCase

  alias PhoenixWebauthn.Login

  describe "users" do
    alias PhoenixWebauthn.Login.Accounts

    import PhoenixWebauthn.LoginFixtures

    @invalid_attrs %{email: nil}

    test "list_users/0 returns all users" do
      accounts = accounts_fixture()
      assert Login.list_users() == [accounts]
    end

    test "get_accounts!/1 returns the accounts with given id" do
      accounts = accounts_fixture()
      assert Login.get_accounts!(accounts.id) == accounts
    end

    test "create_accounts/1 with valid data creates a accounts" do
      valid_attrs = %{email: "some email"}

      assert {:ok, %Accounts{} = accounts} = Login.create_accounts(valid_attrs)
      assert accounts.email == "some email"
    end

    test "create_accounts/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Login.create_accounts(@invalid_attrs)
    end

    test "update_accounts/2 with valid data updates the accounts" do
      accounts = accounts_fixture()
      update_attrs = %{email: "some updated email"}

      assert {:ok, %Accounts{} = accounts} = Login.update_accounts(accounts, update_attrs)
      assert accounts.email == "some updated email"
    end

    test "update_accounts/2 with invalid data returns error changeset" do
      accounts = accounts_fixture()
      assert {:error, %Ecto.Changeset{}} = Login.update_accounts(accounts, @invalid_attrs)
      assert accounts == Login.get_accounts!(accounts.id)
    end

    test "delete_accounts/1 deletes the accounts" do
      accounts = accounts_fixture()
      assert {:ok, %Accounts{}} = Login.delete_accounts(accounts)
      assert_raise Ecto.NoResultsError, fn -> Login.get_accounts!(accounts.id) end
    end

    test "change_accounts/1 returns a accounts changeset" do
      accounts = accounts_fixture()
      assert %Ecto.Changeset{} = Login.change_accounts(accounts)
    end
  end
end
