defmodule SpamzapperWeb.Router do
  use SpamzapperWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

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

  pipeline :guest_layout do
    plug :put_layout, {SpamzapperWeb.LayoutView, :guest}
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through [:browser, :protected]

    get "/registration/edit", RegistrationController, :edit
  end

  scope "/" do
    pipe_through [:browser, :guest_layout]

    pow_routes()
    pow_extension_routes()
  end

  scope "/", SpamzapperWeb do
    pipe_through [:browser, :protected]

    get "/", PageController, :index
  end

  scope "/admin", SpamzapperWeb.Admin, as: :admin do
    pipe_through [:browser, :protected]

    resources "/members", MemberController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpamzapperWeb do
  #   pipe_through :api
  # end
end
