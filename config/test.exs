import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :spamzapper, Spamzapper.Repo,
  username: "postgres",
  password: "postgres",
  database: "spamzapper_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :spamzapper, Spamzapper.ForumRepo,
  database: "dw_forum_test",
  username: "spamzapper",
  password: "GpRrRz4\"K@H_%U]6n{ok3[%X@G5",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spamzapper, SpamzapperWeb.Endpoint,
  http: [port: 4002],
  server: false

# Compile plugs at runtime for faster compilation in tests
config :phoenix, :plug_init_mode, :runtime

# Print only warnings and errors during test
config :logger, level: :warning
