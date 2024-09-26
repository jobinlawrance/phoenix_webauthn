defmodule PhoenixWebauthn.Repo.Migrations.CreateUserCredentials do
  use Ecto.Migration

  def change do
    create table(:user_credentials, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :public_key_spki, :binary
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end
  end
end
