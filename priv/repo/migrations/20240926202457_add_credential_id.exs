defmodule PhoenixWebauthn.Repo.Migrations.AddCredentialId do
  use Ecto.Migration

  def change do
    alter table(:user_credentials) do
      add :credential_id, :string, null: false
    end
  end
end
