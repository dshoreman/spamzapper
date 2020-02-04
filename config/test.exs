use Mix.Config

# Configure your database
config :spamzapper, Spamzapper.Repo,
  username: "postgres",
  password: "postgres",
  database: "spamzapper_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :spamzapper, Spamzapper.ForumRepo,
  database: "dw_forum_test",
  username: "root",
  password: "root",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spamzapper, SpamzapperWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
