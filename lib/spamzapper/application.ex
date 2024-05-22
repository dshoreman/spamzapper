defmodule Spamzapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SpamzapperWeb.Telemetry,
      Spamzapper.Repo,
      Spamzapper.ForumRepo,
      {DNSCluster,
        query: Application.get_env(:sample_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub,
       [
         name: Spamzapper.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Spamzapper.Finch},
      # Start a worker by calling: Spamzapper.Worker.start_link(arg)
      # {Spamzapper.Worker, arg},
      # Start to serve requests, typically the last entry
      SpamzapperWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spamzapper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SpamzapperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
