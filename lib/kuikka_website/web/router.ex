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

  scope "/", KuikkaWebsite.Web.Page do
    pipe_through :browser # Use the default browser stack

    resources "/", HomeController, only: [:index]
    resources "/forums", ForumController
    resources "/events", EventController
    resources "/members", MemberController
    resources "/wiki", WikiController
    resources "/custom", CustomController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KuikkaWebsite.Web.Api do
  #   pipe_through :api
  # end
end
