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
  steamex_route_auth()

  scope "/", Frontend do
    pipe_through [:browser]

    scope "/", Page do
      get "/", HomeController, :index
    end

    scope "/members/", Page do
      get "/", MemberController, :index
      get "/login", MemberController, :login
      get "/logout", MemberController, :logout
    end

    scope "/members/", Page do
      pipe_through [:require_user]

      get "/:id", MemberController, :show
    end
  end
end
