defmodule KuikkaWeb.Router do
  use KuikkaWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(KuikkaWeb.Plug.CurrentUser)
    plug(KuikkaWeb.Plug.Locale)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  # Steamex login
  steamex_route_auth()

  scope "/", KuikkaWeb do
    # Use the default browser stack
    pipe_through(:browser)

    # Homepage
    get("/", HomeController, :index)

    # Forums
    get("/forums", ForumController, :index)
    post("/forums/new", ForumController, :create)
    get("/forums/new", ForumController, :new)
    get("/forums/:id", ForumController, :show)
    put("/forums/:id/edit", ForumController, :update)
    get("/forums/:id/edit", ForumController, :edit)

    # Wiki
    get("/wiki", WikiController, :index)
    post("/wiki/new", WikiController, :create)
    get("/wiki/new", WikiController, :new)
    get("/wiki/:id", WikiController, :show)
    get("/wiki/:id/edit", WikiController, :edit)
    put("/wiki/:id/edit", WikiController, :update)

    # Profiles
    get("/profile/", ProfileController, :index)
    get("/profile/login", ProfileController, :login)
    get("/profile/logout", ProfileController, :logout)
    get("/profile/:id", ProfileController, :profile)
    put("/profile/:id", ProfileController, :update)

    # Events
    get("/events", EventController, :index)
    post("/events/new", EventController, :create)
    get("/events/new", EventController, :new)
    get("/events/:id", EventController, :event)
    get("/events/:id/attend", EventController, :attend)
    get("/events/:id/unattend", EventController, :unattend)
    post("/events/:id", EventController, :create_comment)
    delete("/events/:id", EventController, :delete)
    put("/events/:id/edit", EventController, :update)
    get("/events/:id/edit", EventController, :edit)
    put("/events/:id/:comment_id", EventController, :update_comment)
    delete("/events/:id/:comment_id", EventController, :delete_comment)
  end

  # Other scopes may use custom stacks.
  # scope "/api", KuikkaWeb.Api do
  #   pipe_through :api
  # end
end
