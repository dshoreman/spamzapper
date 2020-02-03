defmodule Spamzapper.Repo do
  use Ecto.Repo,
    otp_app: :spamzapper,
    adapter: Ecto.Adapters.Postgres
end
