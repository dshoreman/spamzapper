defmodule SpamzapperWeb.Admin.UserControllerTest do
  use SpamzapperWeb.ConnCase

  alias Spamzapper.Users

  @create_attrs %{email: "some+email@example.com", password: "some password", password_confirmation: "some password", role: "moderator"}
  @update_attrs %{email: "some_updated+email@example.com", password: "some updated password", password_confirmation: "some updated password", role: "admin"}
  @invalid_attrs %{email: "not an email", password: nil, password_confirmation: nil, role: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{authed_conn: authed_conn} do
      conn = get(authed_conn, ~p"/admin/users")
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/admin/users")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, ~p"/admin/users")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, ~p"/admin/users")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: ~p"/admin/users")
    end
  end

  describe "new user" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, ~p"/admin/users/new")
      assert html_response(conn, 200) =~ "New User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/admin/users/new")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, ~p"/admin/users/new")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, ~p"/admin/users/new")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: ~p"/admin/users/new")
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, ~p"/admin/users", user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/admin/users/#{id}"

      conn = get(authed_conn, ~p"/admin/users/#{id}")
      assert html_response(conn, 200) =~ "User Details"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, ~p"/admin/users", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = post(mod_conn, ~p"/admin/users", user: @create_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = post(unverified_conn, ~p"/admin/users", user: @create_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = post(conn, ~p"/admin/users", user: @create_attrs)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{authed_conn: authed_conn, user: user} do
      conn = get(authed_conn, ~p"/admin/users/#{user}/edit")
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = get(mod_conn, ~p"/admin/users/#{user}/edit")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = get(unverified_conn, ~p"/admin/users/#{user}/edit")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = get(conn, ~p"/admin/users/#{user}/edit")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: ~p"/admin/users/#{user.id}/edit")
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{authed_conn: authed_conn, user: user} do
      conn = put(authed_conn, ~p"/admin/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/admin/users/#{user}"

      conn = get(authed_conn, ~p"/admin/users/#{user}")
      assert html_response(conn, 200) =~ "some_updated+email@example.com"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, user: user} do
      conn = put(authed_conn, ~p"/admin/users/#{user}", user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = put(mod_conn, ~p"/admin/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = put(unverified_conn, ~p"/admin/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = put(conn, ~p"/admin/users/#{user}", user: @update_attrs)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{authed_conn: authed_conn, user: user} do
      conn = delete(authed_conn, ~p"/admin/users/#{user}")
      assert redirected_to(conn) == ~p"/admin/users"
      assert_error_sent 404, fn ->
        get(authed_conn, ~p"/admin/users/#{user}")
      end
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = delete(mod_conn, ~p"/admin/users/#{user}")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = delete(unverified_conn, ~p"/admin/users/#{user}")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/admin/users/#{user}")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
