defmodule SpamzapperWeb.EmailDomainController do
  use SpamzapperWeb, :controller

  alias Spamzapper.Forum
  alias Spamzapper.Forum.Member

  def index(conn, _params) do
    domains = Forum.list_email_domains()
    render(conn, "index.html", title: "Listing Email Domains", domains: domains)
  end

  def show(conn, %{"domain" => domain}) do
    members = Forum.list_members_by_email_domain(domain)

    render(conn, "show.html",
      ban: Forum.get_email_ban(domain),
      domain: domain,
      members: members,
      title: domain
    )
  end
end
