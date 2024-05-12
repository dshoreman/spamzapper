defmodule SpamzapperWeb.PageLiveTest do
  use SpamzapperWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{authed_conn: authed_conn} do
    {:ok, page_live, disconnected_html} = live(authed_conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
  end

  # old PageController tests
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
