defmodule Frontend.Router do
  use Frontend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Frontend do
    pipe_through :browser # Use the default browser stack

    scope "/", Home do
      get "/", HomeController, :get

      get "/login", LoginController, :get
      post "/login", LoginController, :post

      get "/signup", SignupController, :get
      post "/signup", SignupController, :post

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

  # Other scopes may use custom stacks.
  # scope "/api", Frontend do
  #   pipe_through :api
  # end
end
