defmodule PhoenixWebauthn.Repo.Migrations.CreateAuthenticatorDevices do
  use Ecto.Migration

  def change do
    create table(:authenticator_devices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :credential_public_key, :binary
      add :counter, :integer
      add :transports, {:array, :string}
      add :credential_id, references(:user_credentials, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:authenticator_devices, [:credential_id])
  end
end
