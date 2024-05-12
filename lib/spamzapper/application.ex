defmodule Spamzapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Spamzapper.Repo,
      Spamzapper.ForumRepo,
      # Start the Telemetry Supervisor
      SpamzapperWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub,
       [
         name: Spamzapper.PubSub,
         adapter: Phoenix.PubSub.PG2
       ]},
      # Start the Endpoint (http/https)
      SpamzapperWeb.Endpoint
      # Start a worker by calling: Spamzapper.Worker.start_link(arg)
      # {Spamzapper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Spamzapper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SpamzapperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
