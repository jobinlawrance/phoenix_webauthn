defmodule PhoenixWebauthn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PhoenixWebauthnWeb.Telemetry,
      PhoenixWebauthn.Repo,
      {DNSCluster, query: Application.get_env(:phoenix_webauthn, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PhoenixWebauthn.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PhoenixWebauthn.Finch},
      # Start a worker by calling: PhoenixWebauthn.Worker.start_link(arg)
      # {PhoenixWebauthn.Worker, arg},
      # Start to serve requests, typically the last entry
      PhoenixWebauthnWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixWebauthn.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PhoenixWebauthnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
