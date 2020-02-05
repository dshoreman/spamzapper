defmodule SpamzapperWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use SpamzapperWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias Spamzapper.Users.User
      alias SpamzapperWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint SpamzapperWeb.Endpoint

      defp authenticate(%{conn: conn}) do
        user = %User{email: "text@example.com"}
        conn = Pow.Plug.assign_current_user(conn, user, otp_app: :spamzapper)

        {:ok, conn: conn}
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Spamzapper.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Spamzapper.Repo, {:shared, self()})
    end

    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Spamzapper.ForumRepo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Spamzapper.ForumRepo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
