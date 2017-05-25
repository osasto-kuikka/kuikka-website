defmodule KuikkaWebsite.Web.Page.EventController do
  use KuikkaWebsite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
