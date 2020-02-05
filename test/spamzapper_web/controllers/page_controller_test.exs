defmodule SpamzapperWeb.PageControllerTest do
  use SpamzapperWeb.ConnCase

  alias Spamzapper.Users.User

  setup %{conn: conn} do
    user = %User{email: "text@example.com"}
    conn = Pow.Plug.assign_current_user(conn, user, otp_app: :spamzapper)

    {:ok, conn: conn}
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
