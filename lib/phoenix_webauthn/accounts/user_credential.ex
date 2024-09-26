defmodule PhoenixWebauthn.Accounts.UserCredential do
  use Ecto.Schema
  import Ecto.Changeset
  import Logger

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "user_credentials" do
    field :public_key_spki, :binary
    belongs_to :user, PhoenixWebauthn.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(credential, attrs) do
    IO.inspect(credential, label: "Credential before cast")
    IO.inspect(attrs, label: "Attrs passed to changeset")

    result =
      credential
      |> cast(attrs, [:id, :public_key_spki, :user_id])
      |> validate_required([:id, :public_key_spki, :user_id])

    IO.inspect(result, label: "Changeset after cast")
    result
  end
end
