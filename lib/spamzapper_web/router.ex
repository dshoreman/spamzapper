defmodule SpamzapperWeb.Router do
  use SpamzapperWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SpamzapperWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/admin" do
    pipe_through :browser

    resources "/members", SpamzapperWeb.Admin.MemberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpamzapperWeb do
  #   pipe_through :api
  # end
end
