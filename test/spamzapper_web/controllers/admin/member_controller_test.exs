defmodule SpamzapperWeb.MemberControllerTest do
  use SpamzapperWeb.ConnCase

  alias Spamzapper.Forum

  @create_attrs %{group_id: 42, user_allow_pm: true, user_email: "some user_email", user_inactive_time: 42, user_ip: "some user_ip", user_lang: "some user_lang", user_login_attempts: 42, user_posts: 42, user_rank: 42, user_sig: "some user_sig", user_type: 42, user_warnings: 42, user_website: "some user_website", username: "some username"}
  @update_attrs %{group_id: 43, user_allow_pm: false, user_email: "some updated user_email", user_inactive_time: 43, user_ip: "some updated user_ip", user_lang: "some updated user_lang", user_login_attempts: 43, user_posts: 43, user_rank: 43, user_sig: "some updated user_sig", user_type: 43, user_warnings: 43, user_website: "some updated user_website", username: "some updated username"}
  @invalid_attrs %{group_id: nil, user_allow_pm: nil, user_email: nil, user_inactive_time: nil, user_ip: nil, user_lang: nil, user_login_attempts: nil, user_posts: nil, user_rank: nil, user_sig: nil, user_type: nil, user_warnings: nil, user_website: nil, username: nil}

  def fixture(:member) do
    {:ok, member} = Forum.create_member(@create_attrs)
    member
  end

  describe "index" do
    test "lists all members", %{authed_conn: authed_conn} do
      conn = get(authed_conn, ~p"/admin/members")
      assert html_response(conn, 200) =~ "Listing Members"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/admin/members")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, ~p"/admin/members")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, ~p"/admin/members")
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new, request_path: ~p"/admin/members")
    end
  end

  describe "new member" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, ~p"/admin/members/new")
      assert html_response(conn, 200) =~ "New Member"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = get(mod_conn, ~p"/admin/members/new")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = get(unverified_conn, ~p"/admin/members/new")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = get(conn, ~p"/admin/members/new")
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new, request_path: ~p"/admin/members/new")
    end
  end

  describe "create member" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, ~p"/admin/members", member: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/admin/members/#{id}"

      conn = get(authed_conn, ~p"/admin/members/#{id}")
      assert html_response(conn, 200) =~ "Member Details"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, ~p"/admin/members", member: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Member"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn} do
      conn = post(mod_conn, ~p"/admin/members", member: @create_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn} do
      conn = post(unverified_conn, ~p"/admin/members", member: @create_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn} do
      conn = post(conn, ~p"/admin/members", member: @create_attrs)
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new)
    end
  end

  describe "edit member" do
    setup [:create_member]

    test "renders form for editing chosen member", %{authed_conn: authed_conn, member: member} do
      conn = get(authed_conn, ~p"/admin/members/#{member}/edit")
      assert html_response(conn, 200) =~ "Edit #{member.username}"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, member: member} do
      conn = get(mod_conn, ~p"/admin/members/#{member}/edit")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, member: member} do
      conn = get(unverified_conn, ~p"/admin/members/#{member}/edit")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, member: member} do
      conn = get(conn, ~p"/admin/members/#{member}/edit")
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new, request_path: ~p"/admin/members/#{member}/edit")
    end
  end

  describe "update member" do
    setup [:create_member]

    test "redirects when data is valid", %{authed_conn: authed_conn, member: member} do
      conn = put(authed_conn, ~p"/admin/members/#{member}", member: @update_attrs)
      assert redirected_to(conn) == ~p"/admin/members/#{member}"

      conn = get(authed_conn, ~p"/admin/members/#{member}")
      assert html_response(conn, 200) =~ "some updated user_email"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, member: member} do
      conn = put(authed_conn, ~p"/admin/members/#{member}", member: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit #{member.username}"
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, member: member} do
      conn = put(mod_conn, ~p"/admin/members/#{member}", member: @update_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, member: member} do
      conn = put(unverified_conn, ~p"/admin/members/#{member}", member: @update_attrs)
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, member: member} do
      conn = put(conn, ~p"/admin/members/#{member}", member: @update_attrs)
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new)
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{authed_conn: authed_conn, member: member} do
      conn = delete(authed_conn, ~p"/admin/members/#{member}")
      assert redirected_to(conn) == ~p"/admin/members"
      assert_error_sent 404, fn ->
        get(authed_conn, ~p"/admin/members/#{member}")
      end
    end

    test "redirects moderators to dashboard", %{mod_conn: mod_conn, member: member} do
      conn = delete(mod_conn, ~p"/admin/members/#{member}")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects unverified users to dashboard", %{unverified_conn: unverified_conn, member: member} do
      conn = delete(unverified_conn, ~p"/admin/members/#{member}")
      assert redirected_to(conn) == ~p"/"
    end

    test "redirects guests to login", %{conn: conn, member: member} do
      conn = delete(conn, ~p"/admin/members/#{member}")
      assert redirected_to(conn) == Pow.Phoenix.Routes.session_path(conn, :new)
    end
  end

  defp create_member(_) do
    member = fixture(:member)
    {:ok, member: member}
  end
end
