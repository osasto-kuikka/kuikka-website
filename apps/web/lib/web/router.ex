defmodule Web.Router do
  use Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Web.Plug.Locale
    plug Web.Plug.GetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Web do
    pipe_through :browser # Use the default browser stack

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
