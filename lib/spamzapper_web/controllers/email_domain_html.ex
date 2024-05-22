defmodule SpamzapperWeb.EmailDomainHTML do
  use SpamzapperWeb, :html

  import Scrivener.HTML

  embed_templates "email_domain_html/*"

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
  def whitelist, do: @whitelist

  def banned(ban), do: !!ban.ban_email

  def ban_class(ban) do
    case ban_status(ban) do
      "Blacklisted" -> "danger"
      "Whitelisted" -> "success"
      "Unknown" -> "warning"
      "Neutral" -> "light"
    end
  end
  def ban_class(domain, ban) do
    if ban != nil do
      ban_class(ban)
    else
      cond do
        domain in @whitelist -> "success"
        true -> "info"
      end
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
  def ban_status(domain, ban) do
    if ban != nil do
      ban_status(ban)
    else
      cond do
        domain in @whitelist -> "Whitelisted"
        true -> "Neutral"
      end
    end
  end
end
