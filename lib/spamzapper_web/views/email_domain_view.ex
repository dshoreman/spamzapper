defmodule SpamzapperWeb.EmailDomainView do
  use SpamzapperWeb, :view

  def banned(ban), do: !!ban.ban_email

  def ban_class(ban) do
    case ban_status(ban) do
      "Blacklisted" -> "danger"
      "OK" -> "light"
    end
  end

  def ban_status(ban) do
    if banned(ban) do
      "Blacklisted"
    else
      "OK"
    end
  end
end
