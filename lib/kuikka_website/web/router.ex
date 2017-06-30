defmodule KuikkaWebsite.Web.Router do
  use KuikkaWebsite.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug KuikkaWebsite.Web.Plug.GetLayout
    plug KuikkaWebsite.Web.Plug.CurrentUser
    plug KuikkaWebsite.Web.Plug.Locale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Steamex login
  steamex_route_auth()

  scope "/", KuikkaWebsite.Web do
    pipe_through :browser # Use the default browser stack

    resources "/", HomeController, only: [:index]
    resources "/forums", ForumController, only: [:index, :show]
    resources "/members", MemberController, only: [:index, :show]
    resources "/wiki", WikiController, only: [:index, :show]
    resources "/custom", CustomController, only: [:index, :show]

    # Events
    get  "/events",                 EventController, :index
    post "/events",                 EventController, :create
    get  "/events/new",             EventController, :new
    put  "/events/:id",             EventController, :event
    put  "/events/:id",             EventController, :update
    post "/events/:id",             EventController, :create_comment
    get  "/events/:id/edit",        EventController, :edit
    put  "/events/:id/:comment_id", EventController, :update_comment
  end

  # Other scopes may use custom stacks.
  # scope "/api", KuikkaWebsite.Web.Api do
  #   pipe_through :api
  # end
end
