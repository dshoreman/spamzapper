defmodule SpamzapperWeb.Admin.UserController do
  use SpamzapperWeb, :controller

  alias Spamzapper.Users
  alias Spamzapper.Repo
  alias Spamzapper.Users.User

  def index(conn, params) do
    users = Repo.paginate(Users.list_users(), params)
    render(conn, "index.html", title: "Listing Users", users: users)
  end

  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", title: "New User", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: ~p"/admin/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", title: "New User", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.html", title: "User Details", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    changeset = Users.change_user(user)
    render(conn, "edit.html", title: "Edit User", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Users.get_user!(id)

    case Users.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: ~p"/admin/users/#{user}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", title: "Edit User", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    {:ok, _user} = Users.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/admin/users")
  end
end
