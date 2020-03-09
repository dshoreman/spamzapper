defmodule SpamzapperWeb.EmailDomainView do
  use SpamzapperWeb, :view

  @whitelist [
    "aol.com",
    "btinternet.com",
    "gmail.com",
    "gmx.com",
    "hotmail.com",
    "hotmail.co.uk",
    "live.com",
    "outlook.com",
    "yahoo.com",
    "yahoo.co.uk",
  ]

  def banned(ban), do: !!ban.ban_email

  def ban_class(ban) do
    case ban_status(ban) do
      "Blacklisted" -> "danger"
      "Whitelisted" -> "success"
      "Unknown" -> "warning"
      "Neutral" -> "light"
    end
  end

  def ban_status(ban) do
    cond do
      banned(ban) -> "Blacklisted"
      ban.email_domain in @whitelist -> "Whitelisted"
      !ban.ban_email -> "Neutral"
      true -> "Unknown"
    end
  end
end
