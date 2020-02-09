defmodule Spamzapper.Users.UserTest do
  use Spamzapper.DataCase

  alias Spamzapper.Users.User

  test "changeset/2 sets default role" do
    user =
      %User{}
      |> User.changeset(%{})
      |> Ecto.Changeset.apply_changes()

    assert user.role == "unverified"
  end

  test "role_changeset/2" do
    changeset = User.role_changeset(%User{}, %{role: "invalid"})
    assert changeset.errors[:role] == {"is invalid", [
      validation: :inclusion,
      enum: ["unverified", "moderator", "admin"],
    ]}

    changeset = User.role_changeset(%User{}, %{role: "admin"})
    refute changeset.errors[:role]
  end
end
