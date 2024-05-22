defmodule Spamzapper.UsersTest do
  use Spamzapper.DataCase

  alias Spamzapper.Users

  describe "users" do
    alias Spamzapper.Users.User

    @valid_attrs %{email: "some+email@example.com", password: "some password", password_confirmation: "some password", role: "moderator"}
    @update_attrs %{email: "some_updated+email@example.com", password: "some updated password", password_confirmation: "some updated password", role: "admin"}
    @invalid_attrs %{email: nil, password: nil, password_confirmation: nil, role: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Users.create_user()

      %{user | password: nil}
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Users.create_user(@valid_attrs)
      assert user.email == "some+email@example.com"
      assert user.role == "moderator"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "email is required" do
      changeset = User.admin_changeset(%User{}, Map.delete(@valid_attrs, :email))
      assert %{email: ["can't be blank"]} = errors_on(changeset)
    end

    test "password is required" do
      changeset = User.admin_changeset(%User{}, Map.delete(@valid_attrs, :password))
      assert %{password: ["can't be blank"]} = errors_on(changeset)
    end

    test "password must be at least eight characters long" do
      changeset = User.admin_changeset(%User{}, %{@valid_attrs | password: "short", password_confirmation: "short"})
      assert %{password: ["should be at least 8 character(s)"]} = errors_on(changeset)
    end

    test "password must match confirmation" do
      changeset = User.admin_changeset(%User{}, %{@valid_attrs | password_confirmation: "different"})
      assert %{password_confirmation: ["does not match confirmation"]} == errors_on(changeset)
    end

    test "role must be valid" do
      changeset = User.admin_changeset(%User{}, %{@valid_attrs | role: "invalid"})
      assert %{role: ["is invalid"]} == errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Users.update_user(user, @update_attrs)
      assert user.email_confirmation_token != nil
      assert user.unconfirmed_email == "some_updated+email@example.com"
      # POW updated the password field to be redacted, so
      # we'll have to test the new password another way.
      assert user.password == nil
      assert user.role == "admin"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
