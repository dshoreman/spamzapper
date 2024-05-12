defmodule SpamzapperWeb.Router do
  use SpamzapperWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
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

    plug :put_root_layout, {SpamzapperWeb.LayoutView, :root}
  end

  pipeline :admin do
    plug SpamzapperWeb.EnsureRolePlug, :admin
  end

  pipeline :moderator do
    plug SpamzapperWeb.EnsureRolePlug, [:moderator, :admin]
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
    pipe_through [:browser, :protected, :moderator]

    live "/", PageLive, :index
    get "/email-domains", EmailDomainController, :index
    get "/email-domains/:domain", EmailDomainController, :show
    post "/email-domains/:domain/ban", EmailDomainController, :create_ban
  end

  scope "/admin", SpamzapperWeb.Admin, as: :admin do
    pipe_through [:browser, :protected, :admin]

    resources "/members", MemberController
    resources "/users", UserController

    # Enables LiveDashboard only for development
    #
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    if Mix.env() in [:dev, :test] do
      import Phoenix.LiveDashboard.Router

      live_dashboard "/dashboard", metrics: SpamzapperWeb.Telemetry
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpamzapperWeb do
  #   pipe_through :api
  # end
end
