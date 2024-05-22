defmodule SpamzapperWeb.PageLiveTest do
  use SpamzapperWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{authed_conn: authed_conn} do
    {:ok, page_live, disconnected_html} = live(authed_conn, ~p"/")
    assert disconnected_html =~ "Peace of mind from prototype to production"
    assert render(page_live) =~ "Peace of mind from prototype to production"
  end

  # old PageController tests
  describe "index" do
    test "GET /", %{authed_conn: authed_conn} do
      conn = get(authed_conn, ~p"/")
      assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
    end

    test "displays for moderators", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/")
      assert html_response(conn, 200) =~ "Peace of mind from prototype to production"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, ~p"/")
      assert redirected_to(conn) == Routes.page_path(conn, :index)
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, ~p"/")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/")
    end
  end
end
