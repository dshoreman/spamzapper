defmodule SpamzapperWeb.Router do
  use SpamzapperWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
    extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :app_layout do
    plug :put_root_layout, html: {SpamzapperWeb.Layouts, :root}
  end

  pipeline :guest_layout do
    plug :put_layout, html: {SpamzapperWeb.Layouts, :guest}
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :admin do
    plug SpamzapperWeb.EnsureRolePlug, :admin
  end

  pipeline :moderator do
    plug SpamzapperWeb.EnsureRolePlug, [:moderator, :admin]
  end

  scope "/", Pow.Phoenix, as: "pow" do
    pipe_through [:browser, :protected, :app_layout]

    get "/registration/edit", RegistrationController, :edit
  end

  scope "/" do
    pipe_through [:browser, :guest_layout]

    pow_routes()
    pow_extension_routes()
  end

  scope "/", SpamzapperWeb do
    pipe_through [:browser, :protected, :moderator, :app_layout]

    live "/", PageLive, :index
  end

  scope "/", SpamzapperWeb do
    pipe_through [:browser, :protected, :moderator, :app_layout]

    get "/email-domains", EmailDomainController, :index
    get "/email-domains/:domain", EmailDomainController, :show
    post "/email-domains/:domain/ban", EmailDomainController, :create_ban
  end

  scope "/admin", SpamzapperWeb.Admin, as: :admin do
    pipe_through [:browser, :protected, :admin, :app_layout]

    resources "/members", MemberController
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", SpamzapperWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:spamzapper, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:browser, :protected, :admin]

      live_dashboard "/dashboard", metrics: SpamzapperWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
