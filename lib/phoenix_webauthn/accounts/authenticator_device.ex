defmodule PhoenixWebauthn.Accounts.AuthenticatorDevice do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "authenticator_devices" do
    field :counter, :integer
    field :credential_public_key, :binary
    field :transports, {:array, :string}

    belongs_to :user_credential, PhoenixWebauthn.Accounts.UserCredential,
      foreign_key: :credential_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(authenticator_device, attrs) do
    authenticator_device
    |> cast(attrs, [:credential_public_key, :counter, :transports, :credential_id])
    |> validate_required([:credential_public_key, :counter, :transports, :credential_id])
  end
end
