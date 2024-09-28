defmodule PhoenixWebauthn.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias PhoenixWebauthn.Accounts.AuthenticatorDevice
  alias PhoenixWebauthn.Repo

  alias PhoenixWebauthn.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  alias PhoenixWebauthn.Accounts.UserCredential

  @doc """
  Returns the list of user_credentials.

  ## Examples

      iex> list_user_credentials()
      [%UserCredential{}, ...]

  """
  def list_user_credentials do
    Repo.all(UserCredential)
  end

  @doc """
  Gets a single user_credential.

  Raises `Ecto.NoResultsError` if the User credential does not exist.

  ## Examples

      iex> get_user_credential!(123)
      %UserCredential{}

      iex> get_user_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_credential!(id), do: Repo.get!(UserCredential, id)

  @doc """
  Creates a user_credential.

  ## Examples

      iex> create_user_credential(%{field: value})
      {:ok, %UserCredential{}}

      iex> create_user_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_credential(attrs \\ %{}) do
    %UserCredential{}
    |> UserCredential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_credential.

  ## Examples

      iex> update_user_credential(user_credential, %{field: new_value})
      {:ok, %UserCredential{}}

      iex> update_user_credential(user_credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_credential(%UserCredential{} = user_credential, attrs) do
    user_credential
    |> UserCredential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_credential.

  ## Examples

      iex> delete_user_credential(user_credential)
      {:ok, %UserCredential{}}

      iex> delete_user_credential(user_credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_credential(%UserCredential{} = user_credential) do
    Repo.delete(user_credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_credential changes.

  ## Examples

      iex> change_user_credential(user_credential)
      %Ecto.Changeset{data: %UserCredential{}}

  """
  def change_user_credential(%UserCredential{} = user_credential, attrs \\ %{}) do
    UserCredential.changeset(user_credential, attrs)
  end

  alias PhoenixWebauthn.Accounts.UserToken

  @doc """
  Returns the list of users_tokens.

  ## Examples

      iex> list_users_tokens()
      [%UserToken{}, ...]

  """
  def list_users_tokens do
    Repo.all(UserToken)
  end

  @doc """
  Gets a single user_token.

  Raises `Ecto.NoResultsError` if the User token does not exist.

  ## Examples

      iex> get_user_token!(123)
      %UserToken{}

      iex> get_user_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_token!(id), do: Repo.get!(UserToken, id)

  @doc """
  Creates a user_token.

  ## Examples

      iex> create_user_token(%{field: value})
      {:ok, %UserToken{}}

      iex> create_user_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_token(attrs \\ %{}) do
    %UserToken{}
    |> UserToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_token.

  ## Examples

      iex> update_user_token(user_token, %{field: new_value})
      {:ok, %UserToken{}}

      iex> update_user_token(user_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_token(%UserToken{} = user_token, attrs) do
    user_token
    |> UserToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_token.

  ## Examples

      iex> delete_user_token(user_token)
      {:ok, %UserToken{}}

      iex> delete_user_token(user_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_token(%UserToken{} = user_token) do
    Repo.delete(user_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_token changes.

  ## Examples

      iex> change_user_token(user_token)
      %Ecto.Changeset{data: %UserToken{}}

  """
  def change_user_token(%UserToken{} = user_token, attrs \\ %{}) do
    UserToken.changeset(user_token, attrs)
  end

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  ## User registration

  @doc """
  Registers a user.
  """
  require Logger

  def register_user(email, credential_id, public_key_spki, device) do
    Repo.transaction(fn ->
      with {:ok, user} <- create_user(email),
           {:ok, credential} <- create_user_credential(user, credential_id, public_key_spki),
           {:ok, _device} <- create_authenticator_device(credential, device) do
        user
      else
        {:error, operation, changeset, _changes_so_far} ->
          log_error(operation, changeset)
          Repo.rollback({operation, changeset})
      end
    end)
  end

  defp create_user(email) do
    %User{}
    |> User.registration_changeset(%{email: email})
    |> Repo.insert()
  end

  defp create_user_credential(user, credential_id, public_key_spki) do
    %UserCredential{}
    |> UserCredential.changeset(%{
      credential_id: credential_id,
      public_key_spki: public_key_spki,
      user_id: user.id
    })
    |> Repo.insert()
  end

  defp create_authenticator_device(credential, device) do
    device_params = Jason.decode!(device)
    credential_public_key_base64 = device_params["credentialPublicKeyBase64"]

    with {:ok, credential_public_key_binary} <-
           Base.url_decode64(credential_public_key_base64, padding: false) do
      %AuthenticatorDevice{}
      |> AuthenticatorDevice.changeset(%{
        counter: device_params["counter"],
        credential_public_key: credential_public_key_binary,
        transports: device_params["transports"],
        credential_id: credential.id
      })
      |> Repo.insert()
    else
      :error -> {:error, :authenticator_device, "Invalid Base64 encoding", %{}}
    end
  end

  defp log_error(operation, changeset) do
    error_messages =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    error_string =
      Enum.map_join(error_messages, ", ", fn {k, v} -> "#{k}: #{Enum.join(v, ", ")}" end)

    Logger.error("#{operation} failed: #{error_string}")
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.
  """
  def apply_user_email(user, attrs) do
    user
    |> User.email_changeset(attrs)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, [context]))
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    :ok
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.user_and_contexts_query(user, ["confirm"]))
  end

  def get_credential(id) do
    Repo.get(UserCredential, id)
    |> Repo.preload(:user)
  end

  def get_credentials_by_email(email) do
    Repo.one(
      from u in User,
        where: u.email == ^email,
        preload: [credentials: :authenticator_device]
    )
    |> case do
      %{credentials: credentials} -> credentials
      nil -> []
    end
  end

  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")

      with {:ok, _token} <- Repo.insert(user_token) do
        # UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
        {:ok, encoded_token}
      end
    end
  end

  alias PhoenixWebauthn.Accounts.AuthenticatorDevice

  @doc """
  Returns the list of authenticator_devices.

  ## Examples

      iex> list_authenticator_devices()
      [%AuthenticatorDevice{}, ...]

  """
  def list_authenticator_devices do
    Repo.all(AuthenticatorDevice)
  end

  @doc """
  Gets a single authenticator_device.

  Raises `Ecto.NoResultsError` if the Authenticator device does not exist.

  ## Examples

      iex> get_authenticator_device!(123)
      %AuthenticatorDevice{}

      iex> get_authenticator_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_authenticator_device!(id), do: Repo.get!(AuthenticatorDevice, id)

  @doc """
  Creates a authenticator_device.

  ## Examples

      iex> create_authenticator_device(%{field: value})
      {:ok, %AuthenticatorDevice{}}

      iex> create_authenticator_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_authenticator_device(attrs \\ %{}) do
    %AuthenticatorDevice{}
    |> AuthenticatorDevice.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a authenticator_device.

  ## Examples

      iex> update_authenticator_device(authenticator_device, %{field: new_value})
      {:ok, %AuthenticatorDevice{}}

      iex> update_authenticator_device(authenticator_device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_authenticator_device(%AuthenticatorDevice{} = authenticator_device, attrs) do
    authenticator_device
    |> AuthenticatorDevice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a authenticator_device.

  ## Examples

      iex> delete_authenticator_device(authenticator_device)
      {:ok, %AuthenticatorDevice{}}

      iex> delete_authenticator_device(authenticator_device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_authenticator_device(%AuthenticatorDevice{} = authenticator_device) do
    Repo.delete(authenticator_device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking authenticator_device changes.

  ## Examples

      iex> change_authenticator_device(authenticator_device)
      %Ecto.Changeset{data: %AuthenticatorDevice{}}

  """
  def change_authenticator_device(%AuthenticatorDevice{} = authenticator_device, attrs \\ %{}) do
    AuthenticatorDevice.changeset(authenticator_device, attrs)
  end
end
