defmodule SpamzapperWeb.PageControllerTest do
  use SpamzapperWeb.ConnCase

  describe "index" do
    setup [:authenticate]

    test "GET /", %{conn: conn} do
      conn = get(conn, "/")
      assert html_response(conn, 200) =~ "Welcome to Phoenix!"
    end
  end

  describe "guest index" do
    test "redirects to login", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/")
    end
  end
end
