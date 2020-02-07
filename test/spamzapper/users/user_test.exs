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

  test "changeset_role/2" do
    changeset = User.changeset_role(%User{}, %{role: "invalid"})
    assert changeset.errors[:role] == {"is invalid", [
      validation: :inclusion,
      enum: ["unverified", "moderator", "admin"],
    ]}

    changeset = User.changeset_role(%User{}, %{role: "admin"})
    refute changeset.errors[:role]
  end
end
