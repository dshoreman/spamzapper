defmodule SpamzapperWeb.PageControllerTest do
  use SpamzapperWeb.ConnCase

  describe "index" do
    test "GET /", %{authed_conn: authed_conn} do
      conn = get(authed_conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end

    test "displays for moderators", %{mod_conn: mod_conn} do
      conn = get(mod_conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, "/")
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/")
    end
  end
end
