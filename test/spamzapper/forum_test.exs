defmodule Spamzapper.ForumTest do
  use Spamzapper.DataCase

  alias Spamzapper.Forum

  describe "members" do
    alias Spamzapper.Forum.Member

    @valid_attrs %{group_id: 42, user_allow_pm: true, user_email: "some user_email", user_inactive_time: 42, user_ip: "some user_ip", user_lang: "some user_lang", user_login_attempts: 42, user_posts: 42, user_rank: 42, user_sig: "some user_sig", user_type: 42, user_warnings: 42, user_website: "some user_website", username: "some username"}
    @update_attrs %{group_id: 43, user_allow_pm: false, user_email: "some updated user_email", user_inactive_time: 43, user_ip: "some updated user_ip", user_lang: "some updated user_lang", user_login_attempts: 43, user_posts: 43, user_rank: 43, user_sig: "some updated user_sig", user_type: 43, user_warnings: 43, user_website: "some updated user_website", username: "some updated username"}
    @invalid_attrs %{group_id: nil, user_allow_pm: nil, user_email: nil, user_inactive_time: nil, user_ip: nil, user_lang: nil, user_login_attempts: nil, user_posts: nil, user_rank: nil, user_sig: nil, user_type: nil, user_warnings: nil, user_website: nil, username: nil}

    def member_fixture(attrs \\ %{}) do
      {:ok, member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Forum.create_member()

      member
    end

    test "list_members/0 returns all members" do
      member = member_fixture()
      assert Forum.list_members() == [member]
    end

    test "get_member!/1 returns the member with given id" do
      member = member_fixture()
      assert Forum.get_member!(member.user_id) == member
    end

    test "create_member/1 with valid data creates a member" do
      assert {:ok, %Member{} = member} = Forum.create_member(@valid_attrs)
      assert member.group_id == 42
      assert member.user_allow_pm == true
      assert member.user_email == "some user_email"
      assert member.user_inactive_time == 42
      assert member.user_ip == "some user_ip"
      assert member.user_lang == "some user_lang"
      assert member.user_login_attempts == 42
      assert member.user_posts == 42
      assert member.user_rank == 42
      assert member.user_sig == "some user_sig"
      assert member.user_type == 42
      assert member.user_warnings == 42
      assert member.user_website == "some user_website"
      assert member.username == "some username"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      member = member_fixture()
      assert {:ok, %Member{} = member} = Forum.update_member(member, @update_attrs)
      assert member.group_id == 43
      assert member.user_allow_pm == false
      assert member.user_email == "some updated user_email"
      assert member.user_inactive_time == 43
      assert member.user_ip == "some updated user_ip"
      assert member.user_lang == "some updated user_lang"
      assert member.user_login_attempts == 43
      assert member.user_posts == 43
      assert member.user_rank == 43
      assert member.user_sig == "some updated user_sig"
      assert member.user_type == 43
      assert member.user_warnings == 43
      assert member.user_website == "some updated user_website"
      assert member.username == "some updated username"
    end

    test "update_member/2 with invalid data returns error changeset" do
      member = member_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_member(member, @invalid_attrs)
      assert member == Forum.get_member!(member.user_id)
    end

    test "delete_member/1 deletes the member" do
      member = member_fixture()
      assert {:ok, %Member{}} = Forum.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_member!(member.user_id) end
    end

    test "change_member/1 returns a member changeset" do
      member = member_fixture()
      assert %Ecto.Changeset{} = Forum.change_member(member)
    end
  end
end
