defmodule Frontend.Router do
  use Frontend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Frontend.Plug.Locale
    plug Frontend.Plug.GetUser
    plug Frontend.Plug.GetPermissions
    plug Frontend.Plug.NextEvent
  end

  pipeline :require_user do
    plug Frontend.Plug.RequireUser
  end

  # Generate steamex auth route
  steamex_route_auth()

  scope "/", Frontend do
    pipe_through [:browser]

    scope "/", Page do
      resources "/", HomeController, only: [:index]
      resources "/members", MemberController, only: [:index, :show]
      resources "/forum", ForumController, only: [:index, :show,
                                                  :create, :update]
      resources "/wiki", WikiController, only: [:index, :show, :create]
      resources "/event", EventController, only: [:index, :show,
                                                  :create, :update]
    end
  end
end
