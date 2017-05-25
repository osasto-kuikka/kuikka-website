defmodule KuikkaWebsite.Web.Router do
  use KuikkaWebsite.Web, :router

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

  scope "/", KuikkaWebsite.Web.Page do
    pipe_through :browser # Use the default browser stack

    resources "/", HomeController, only: [:index]
    resources "/forums", ForumController
    resources "/events", EventController
    resources "/members", MemberController
    resources "/wiki", WikiController
  end

  # Other scopes may use custom stacks.
  # scope "/api", KuikkaWebsite.Web.Api do
  #   pipe_through :api
  # end
end
