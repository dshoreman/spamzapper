defmodule SpamzapperWeb.EmailDomainController do
  use SpamzapperWeb, :controller

  alias Spamzapper.Forum
  alias Spamzapper.Forum.Member

  def index(conn, _params) do
    domains = Forum.list_email_domains()
    render(conn, "index.html", title: "Listing Email Domains", domains: domains)
  end
end
