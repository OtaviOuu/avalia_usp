defmodule AvaliaUsp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AvaliaUspWeb.Telemetry,
      AvaliaUsp.Repo,
      {DNSCluster, query: Application.get_env(:avalia_usp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AvaliaUsp.PubSub},
      # Start a worker by calling: AvaliaUsp.Worker.start_link(arg)
      # {AvaliaUsp.Worker, arg},
      # Start to serve requests, typically the last entry
      AvaliaUspWeb.Endpoint,
      {AshAuthentication.Supervisor, [otp_app: :avalia_usp]},
      AvaliaUsp.Vault
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AvaliaUsp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AvaliaUspWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
