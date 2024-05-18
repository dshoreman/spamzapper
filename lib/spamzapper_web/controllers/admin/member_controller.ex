defmodule SpamzapperWeb.Admin.MemberController do
  use SpamzapperWeb, :old_controller

  alias Spamzapper.Forum
  alias Spamzapper.Forum.Member

  def index(conn, params) do
    page = Forum.list_members(params)

    render(conn, "index.html",
      title: "Listing Members",
      members: page.entries,
      page: page
    )
  end

  def new(conn, _params) do
    changeset = Forum.change_member(%Member{})
    render(conn, "new.html", title: "New Member", changeset: changeset)
  end

  def create(conn, %{"member" => member_params}) do
    case Forum.create_member(member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member created successfully.")
        |> redirect(to: Routes.admin_member_path(conn, :show, member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", title: "New Member", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    member = Forum.get_member!(id)
    render(conn, "show.html", title: "Member Details", member: member)
  end

  def edit(conn, %{"id" => id}) do
    member = Forum.get_member!(id)
    changeset = Forum.change_member(member)
    render(conn, "edit.html", title: "Edit #{member.username}", member: member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "member" => member_params}) do
    member = Forum.get_member!(id)

    case Forum.update_member(member, member_params) do
      {:ok, member} ->
        conn
        |> put_flash(:info, "Member updated successfully.")
        |> redirect(to: Routes.admin_member_path(conn, :show, member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", title: "Edit #{member.username}", member: member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    member = Forum.get_member!(id)
    {:ok, _member} = Forum.delete_member(member)

    conn
    |> put_flash(:info, "Member deleted successfully.")
    |> redirect(to: Routes.admin_member_path(conn, :index))
  end
end
