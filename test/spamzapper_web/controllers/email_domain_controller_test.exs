defmodule SpamzapperWeb.EmailDomainControllerTest do
  use SpamzapperWeb.ConnCase

  alias Spamzapper.Forum

  describe "index" do
    test "lists all email domains", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/email-domains")
      assert html_response(conn, 200) =~ "Listing Email Domains"
    end
  end
end
