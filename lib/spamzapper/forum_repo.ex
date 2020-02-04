defmodule Spamzapper.ForumRepo do
  use Ecto.Repo,
    otp_app: :spamzapper,
    adapter: Ecto.Adapters.MyXQL
end
