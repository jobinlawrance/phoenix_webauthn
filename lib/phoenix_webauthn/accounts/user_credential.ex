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

    timestamps(type: :utc_datetime)
  end

  def changeset(credential, attrs) do
    result =
      credential
      |> cast(attrs, [:credential_id, :public_key_spki, :user_id])
      |> validate_required([:credential_id, :public_key_spki, :user_id])

    result
  end
end
