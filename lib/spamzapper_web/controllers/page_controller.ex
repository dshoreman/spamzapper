defmodule SpamzapperWeb.PageController do
  use SpamzapperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
