defmodule PhoenixWebauthn.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_webauthn,
    adapter: Ecto.Adapters.Postgres
end
