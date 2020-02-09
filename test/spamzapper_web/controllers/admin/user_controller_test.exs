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
      conn = get(authed_conn, Routes.admin_user_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Users"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, Routes.admin_user_path(mod_conn, :index))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, Routes.admin_user_path(unverified_conn, :index))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :index))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/admin/users")
    end
  end

  describe "new user" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.admin_user_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, Routes.admin_user_path(mod_conn, :new))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, Routes.admin_user_path(unverified_conn, :new))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, Routes.admin_user_path(conn, :new))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/admin/users/new")
    end
  end

  describe "create user" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.admin_user_path(authed_conn, :create), user: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_user_path(authed_conn, :show, id)

      conn = get(authed_conn, Routes.admin_user_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Show User"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.admin_user_path(authed_conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = post(mod_conn, Routes.admin_user_path(mod_conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = post(unverified_conn, Routes.admin_user_path(unverified_conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn} do
      conn = post(conn, Routes.admin_user_path(conn, :create), user: @create_attrs)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  describe "edit user" do
    setup [:create_user]

    test "renders form for editing chosen user", %{authed_conn: authed_conn, user: user} do
      conn = get(authed_conn, Routes.admin_user_path(authed_conn, :edit, user))
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = get(mod_conn, Routes.admin_user_path(mod_conn, :edit, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = get(unverified_conn, Routes.admin_user_path(unverified_conn, :edit, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = get(conn, Routes.admin_user_path(conn, :edit, user))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/admin/users/#{user.id}/edit")
    end
  end

  describe "update user" do
    setup [:create_user]

    test "redirects when data is valid", %{authed_conn: authed_conn, user: user} do
      conn = put(authed_conn, Routes.admin_user_path(authed_conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.admin_user_path(authed_conn, :show, user)

      conn = get(authed_conn, Routes.admin_user_path(authed_conn, :show, user))
      assert html_response(conn, 200) =~ "some_updated+email@example.com"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, user: user} do
      conn = put(authed_conn, Routes.admin_user_path(authed_conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = put(mod_conn, Routes.admin_user_path(mod_conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = put(unverified_conn, Routes.admin_user_path(unverified_conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = put(conn, Routes.admin_user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{authed_conn: authed_conn, user: user} do
      conn = delete(authed_conn, Routes.admin_user_path(authed_conn, :delete, user))
      assert redirected_to(conn) == Routes.admin_user_path(authed_conn, :index)
      assert_error_sent 404, fn ->
        get(authed_conn, Routes.admin_user_path(authed_conn, :show, user))
      end
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, user: user} do
      conn = delete(mod_conn, Routes.admin_user_path(mod_conn, :delete, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, user: user} do
      conn = delete(unverified_conn, Routes.admin_user_path(unverified_conn, :delete, user))
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn, user: user} do
      conn = delete(conn, Routes.admin_user_path(conn, :delete, user))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new)
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
