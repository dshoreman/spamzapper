defmodule SpamzapperWeb.MemberControllerTest do
  use SpamzapperWeb.ConnCase

  alias Spamzapper.Forum
  alias Spamzapper.Users.User

  @create_attrs %{group_id: 42, user_allow_pm: true, user_email: "some user_email", user_inactive_time: 42, user_ip: "some user_ip", user_lang: "some user_lang", user_login_attempts: 42, user_posts: 42, user_rank: 42, user_sig: "some user_sig", user_type: 42, user_warnings: 42, user_website: "some user_website", username: "some username"}
  @update_attrs %{group_id: 43, user_allow_pm: false, user_email: "some updated user_email", user_inactive_time: 43, user_ip: "some updated user_ip", user_lang: "some updated user_lang", user_login_attempts: 43, user_posts: 43, user_rank: 43, user_sig: "some updated user_sig", user_type: 43, user_warnings: 43, user_website: "some updated user_website", username: "some updated username"}
  @invalid_attrs %{group_id: nil, user_allow_pm: nil, user_email: nil, user_inactive_time: nil, user_ip: nil, user_lang: nil, user_login_attempts: nil, user_posts: nil, user_rank: nil, user_sig: nil, user_type: nil, user_warnings: nil, user_website: nil, username: nil}

  setup %{conn: conn} do
    user = %User{email: "text@example.com"}
    conn = Pow.Plug.assign_current_user(conn, user, otp_app: :spamzapper)

    {:ok, conn: conn}
  end

  def fixture(:member) do
    {:ok, member} = Forum.create_member(@create_attrs)
    member
  end

  describe "index" do
    test "lists all members", %{conn: conn} do
      conn = get(conn, Routes.member_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Members"
    end
  end

  describe "new member" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.member_path(conn, :new))
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "create member" do
    test "redirects to show when data is valid", %{conn: conn} do
      resp = post(conn, Routes.member_path(conn, :create), member: @create_attrs)

      assert %{id: id} = redirected_params(resp)
      assert redirected_to(resp) == Routes.member_path(conn, :show, id)

      conn = get(conn, Routes.member_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Member"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.member_path(conn, :create), member: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Member"
    end
  end

  describe "edit member" do
    setup [:create_member]

    test "renders form for editing chosen member", %{conn: conn, member: member} do
      conn = get(conn, Routes.member_path(conn, :edit, member))
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "update member" do
    setup [:create_member]

    test "redirects when data is valid", %{conn: conn, member: member} do
      resp = put(conn, Routes.member_path(conn, :update, member), member: @update_attrs)
      assert redirected_to(resp) == Routes.member_path(conn, :show, member)

      conn = get(conn, Routes.member_path(conn, :show, member))
      assert html_response(conn, 200) =~ "some updated user_email"
    end

    test "renders errors when data is invalid", %{conn: conn, member: member} do
      conn = put(conn, Routes.member_path(conn, :update, member), member: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Member"
    end
  end

  describe "delete member" do
    setup [:create_member]

    test "deletes chosen member", %{conn: conn, member: member} do
      resp = delete(conn, Routes.member_path(conn, :delete, member))
      assert redirected_to(resp) == Routes.member_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.member_path(conn, :show, member))
      end
    end
  end

  defp create_member(_) do
    member = fixture(:member)
    {:ok, member: member}
  end
end
