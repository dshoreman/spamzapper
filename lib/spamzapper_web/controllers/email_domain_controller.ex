defmodule SpamzapperWeb.EmailDomainController do
  use SpamzapperWeb, :controller

  alias Spamzapper.Forum
  alias Spamzapper.ForumRepo
  alias Spamzapper.Forum.Ban

  def index(conn, params) do
    domains = ForumRepo.paginate(Forum.list_email_domains(), params)
    render(conn, "index.html", title: "Listing Email Domains", domains: domains)
  end

  def show(conn, %{"domain" => domain}) do
    members = ForumRepo.paginate(Forum.list_members_by_email_domain(domain), conn.query_params)
    changeset = Forum.change_email_ban(%Ban{})

    render(conn, "show.html",
      ban: Forum.get_email_ban(domain),
      changeset: changeset,
      domain: domain,
      members: members,
      title: domain
    )
  end

  def create_ban(conn, %{"domain" => domain}) do
    case Forum.create_email_ban(%{"ban_email" => "*@#{domain}"}) do
      {:ok, _ban} ->
        conn
        |> put_flash(:info, "Domain #{domain} was blacklisted successfully.")
        |> redirect(to: Routes.email_domain_path(conn, :show, domain))

      {:error, %Ecto.Changeset{} = changeset} ->
        members = Forum.list_members_by_email_domain(domain)
        render(conn, "show.html",
          ban: Forum.get_email_ban(domain),
          changeset: changeset,
          domain: domain,
          members: members,
          title: domain
        )
    end
  end
end
