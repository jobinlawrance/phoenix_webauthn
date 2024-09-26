defmodule PhoenixWebauthn.AccountsTest do
  use PhoenixWebauthn.DataCase

  alias PhoenixWebauthn.Accounts

  describe "users" do
    alias PhoenixWebauthn.Accounts.User

    import PhoenixWebauthn.AccountsFixtures

    @invalid_attrs %{email: nil, confirmed_at: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", confirmed_at: ~N[2024-09-25 10:05:00]}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.confirmed_at == ~N[2024-09-25 10:05:00]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{email: "some updated email", confirmed_at: ~N[2024-09-26 10:05:00]}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.confirmed_at == ~N[2024-09-26 10:05:00]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "user_credentials" do
    alias PhoenixWebauthn.Accounts.UserCredential

    import PhoenixWebauthn.AccountsFixtures

    @invalid_attrs %{public_key_spki: nil}

    test "list_user_credentials/0 returns all user_credentials" do
      user_credential = user_credential_fixture()
      assert Accounts.list_user_credentials() == [user_credential]
    end

    test "get_user_credential!/1 returns the user_credential with given id" do
      user_credential = user_credential_fixture()
      assert Accounts.get_user_credential!(user_credential.id) == user_credential
    end

    test "create_user_credential/1 with valid data creates a user_credential" do
      valid_attrs = %{public_key_spki: "some public_key_spki"}

      assert {:ok, %UserCredential{} = user_credential} =
               Accounts.create_user_credential(valid_attrs)

      assert user_credential.public_key_spki == "some public_key_spki"
    end

    test "create_user_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_credential(@invalid_attrs)
    end

    test "update_user_credential/2 with valid data updates the user_credential" do
      user_credential = user_credential_fixture()
      update_attrs = %{public_key_spki: "some updated public_key_spki"}

      assert {:ok, %UserCredential{} = user_credential} =
               Accounts.update_user_credential(user_credential, update_attrs)

      assert user_credential.public_key_spki == "some updated public_key_spki"
    end

    test "update_user_credential/2 with invalid data returns error changeset" do
      user_credential = user_credential_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_user_credential(user_credential, @invalid_attrs)

      assert user_credential == Accounts.get_user_credential!(user_credential.id)
    end

    test "delete_user_credential/1 deletes the user_credential" do
      user_credential = user_credential_fixture()
      assert {:ok, %UserCredential{}} = Accounts.delete_user_credential(user_credential)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user_credential!(user_credential.id)
      end
    end

    test "change_user_credential/1 returns a user_credential changeset" do
      user_credential = user_credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_credential(user_credential)
    end
  end

  describe "users_tokens" do
    alias PhoenixWebauthn.Accounts.UserToken

    import PhoenixWebauthn.AccountsFixtures

    @invalid_attrs %{context: nil, token: nil, sent_to: nil}

    test "list_users_tokens/0 returns all users_tokens" do
      user_token = user_token_fixture()
      assert Accounts.list_users_tokens() == [user_token]
    end

    test "get_user_token!/1 returns the user_token with given id" do
      user_token = user_token_fixture()
      assert Accounts.get_user_token!(user_token.id) == user_token
    end

    test "create_user_token/1 with valid data creates a user_token" do
      valid_attrs = %{context: "some context", token: "some token", sent_to: "some sent_to"}

      assert {:ok, %UserToken{} = user_token} = Accounts.create_user_token(valid_attrs)
      assert user_token.context == "some context"
      assert user_token.token == "some token"
      assert user_token.sent_to == "some sent_to"
    end

    test "create_user_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_token(@invalid_attrs)
    end

    test "update_user_token/2 with valid data updates the user_token" do
      user_token = user_token_fixture()

      update_attrs = %{
        context: "some updated context",
        token: "some updated token",
        sent_to: "some updated sent_to"
      }

      assert {:ok, %UserToken{} = user_token} =
               Accounts.update_user_token(user_token, update_attrs)

      assert user_token.context == "some updated context"
      assert user_token.token == "some updated token"
      assert user_token.sent_to == "some updated sent_to"
    end

    test "update_user_token/2 with invalid data returns error changeset" do
      user_token = user_token_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_token(user_token, @invalid_attrs)
      assert user_token == Accounts.get_user_token!(user_token.id)
    end

    test "delete_user_token/1 deletes the user_token" do
      user_token = user_token_fixture()
      assert {:ok, %UserToken{}} = Accounts.delete_user_token(user_token)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_token!(user_token.id) end
    end

    test "change_user_token/1 returns a user_token changeset" do
      user_token = user_token_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_token(user_token)
    end
  end
end
