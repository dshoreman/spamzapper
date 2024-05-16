import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :spamzapper, Spamzapper.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "spamzapper_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :spamzapper, Spamzapper.ForumRepo,
  database: "dw_forum_test",
  username: "spamzapper",
  password: "GpRrRz4\"K@H_%U]6n{ok3[%X@G5",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :spamzapper, SpamzapperWeb.Endpoint,
  http: [ip: {127,0,0,1}, port: 4002],
  secret_key_base: "+jrLHK0a2gmUrROIqE6Fz7mvxe+R2gQWIVUKkXGs2j8bxLnbAcHoOajYadj1F2eY",
  server: false

# In test we don't send emails.
config :spamzapper, Spamzapper.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
