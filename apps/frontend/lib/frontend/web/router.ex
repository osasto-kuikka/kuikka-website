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
      get "/", HomeController, :get

      scope "/profile/" do
        pipe_through [:require_user]

        get "/logout", ProfileController, :logout
        get "/user/:id", ProfileController, :get
      end
    end
  end
end
