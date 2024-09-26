defmodule PhoenixWebauthn.Repo.Migrations.AddDevice do
  use Ecto.Migration

  def change do
    alter table(:user_credentials) do
      add :device, :text
    end
  end
end
