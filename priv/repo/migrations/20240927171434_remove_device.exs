defmodule PhoenixWebauthn.Repo.Migrations.RemoveDevice do
  use Ecto.Migration

  def change do
    alter table(:user_credentials) do
      remove :device
    end
  end
end
