defmodule PhoenixWebauthn.Accounts.UserCredential do
  use Ecto.Schema
  import Ecto.Changeset
  import Logger

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "user_credentials" do
    field :public_key_spki, :binary
    field :credential_id, :string
    belongs_to :user, PhoenixWebauthn.Accounts.User

    has_one :authenticator_device, PhoenixWebauthn.Accounts.AuthenticatorDevice,
      foreign_key: :credential_id

    timestamps(type: :utc_datetime)
  end

  def changeset(credential, attrs) do
    result =
      credential
      |> cast(attrs, [:credential_id, :public_key_spki, :user_id])
      |> validate_required([:credential_id, :public_key_spki, :user_id])

    result
  end

  defp validate_json(changeset, field) do
    validate_change(changeset, field, fn _, value ->
      case Jason.encode(value) do
        # Valid JSON
        {:ok, _} -> []
        {:error, _} -> [{field, "must be valid JSON"}]
      end
    end)
  end
end
