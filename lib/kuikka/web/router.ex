defmodule Kuikka.Web.Router do
  use Kuikka.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Kuikka.Web.Plug.GetLayout
    plug Kuikka.Web.Plug.CurrentUser
    plug Kuikka.Web.Plug.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Steamex login
  steamex_route_auth()

  scope "/", Kuikka.Web do
    pipe_through :browser # Use the default browser stack

    # Homepage
    get "/",                        HomeController, :index

    # Forums
    get  "/forums",                 ForumController, :index
    post "/forums",                 ForumController, :create
    get  "/forums/new",             ForumController, :new
    get  "/forums/:id",             ForumController, :show
    put  "/forums/:id",             ForumController, :update
    get  "/forums/:id/edit",        ForumController, :edit

    # Wiki
    get  "/wiki",                   WikiController, :index
    post "/wiki",                   WikiController, :create
    get  "/wiki/new",               WikiController, :new
    get  "/wiki/:id",               WikiController, :show
    put  "/wiki/:id",               WikiController, :update
    get  "/wiki/:id/edit",          WikiController, :edit

    # Profiles
    get "/profile/",                ProfileController, :index
    get "/profile/login",           ProfileController, :login
    get "/profile/logout",          ProfileController, :logout
    get "/profile/:id",             ProfileController, :profile
    put "/profile/:id",             ProfileController, :update

    # Events
    get  "/events",                 EventController, :index
    post "/events",                 EventController, :create
    get  "/events/new",             EventController, :new
    get  "/events/:id",             EventController, :event
    put  "/events/:id",             EventController, :update
    post "/events/:id",             EventController, :create_comment
    get  "/events/:id/edit",        EventController, :edit
    put  "/events/:id/:comment_id", EventController, :update_comment
  end

  # Other scopes may use custom stacks.
  # scope "/api", Kuikka.Web.Api do
  #   pipe_through :api
  # end
end
