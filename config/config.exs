# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :scrivener_html,
  routes_helper: SpamzapperWeb.Router.Helpers,
  view_style: :bootstrap_v4

config :spamzapper,
  ecto_repos: [Spamzapper.Repo, Spamzapper.ForumRepo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :spamzapper, SpamzapperWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SpamzapperWeb.ErrorHTML, json: SpamzapperWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Spamzapper.PubSub,
  live_view: [signing_salt: "aaaaaaaa"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :spamzapper, Spamzapper.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  spamzapper: [
    args: ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  spamzapper: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

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
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: SpamzapperWeb.PowMailer,
  web_module: SpamzapperWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
