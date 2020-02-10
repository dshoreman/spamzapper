defmodule Spamzapper.Users.UserTest do
  use Spamzapper.DataCase

  alias Spamzapper.Users.User

  describe "changeset/2" do
    test "sets default role" do
      user =
        %User{}
        |> User.changeset(%{})
        |> Ecto.Changeset.apply_changes()

      assert "unverified" == user.role
    end

    test "cannot override role" do
      user = %User{}
        |> User.changeset(%{role: "admin"})
        |> Ecto.Changeset.apply_changes()

      assert "unverified" == user.role
    end
  end

  describe "admin_changeset/2" do
    test "validates role" do
      changeset = User.admin_changeset(%User{}, %{role: "invalid"})
      assert changeset.errors[:role] == {"is invalid", [
        validation: :inclusion,
        enum: ["unverified", "moderator", "admin"],
      ]}

      changeset = User.admin_changeset(%User{}, %{role: "admin"})
      refute changeset.errors[:role]
    end
  end
end
