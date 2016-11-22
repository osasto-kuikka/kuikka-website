defmodule Frontend.Router do
  use Frontend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Frontend.Auth.GetUser
  end

  pipeline :require_user do
    plug Frontend.Auth.RequireUser
  end

  # Generate steamex auth route
  steamex_route_auth

  scope "/", Frontend do
    pipe_through [:browser]

    scope "/", Home do
      get "/", HomeController, :get

      get "/news", NewsController, :get
      get "/forum", ForumController, :get
      get "/media", MediaController, :get
      get "/roster", RosterController, :get
      get "/wiki", WikiController, :get
    end

    scope "/kuikka", Kuikka do
      get "/profile", ProfileController, :get
      put "/profile", ProfileController, :put
      post "/profile", ProfileController, :post
    end
  end
end
