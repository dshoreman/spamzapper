# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :spamzapper,
  ecto_repos: [Spamzapper.Repo, Spamzapper.ForumRepo]

# Configures the endpoint
config :spamzapper, SpamzapperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "P5VEu1FeeF6d9xV2MQpyrs86mhhX+YU51NxEgv/MF2/jxCITJb5jpPoxtIY9ki4V",
  render_errors: [view: SpamzapperWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Spamzapper.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Pow for authentication
config :spamzapper, :pow,
  user: Spamzapper.Users.User,
  repo: Spamzapper.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: SpamzapperWeb.PowMailer,
  web_module: SpamzapperWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
