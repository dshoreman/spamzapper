defmodule Spamzapper.Repo do
  use Ecto.Repo,
    otp_app: :spamzapper,
    adapter: Ecto.Adapters.Postgres

  use Scrivener,
    page_size: 25
end
