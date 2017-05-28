defmodule KuikkaWebsite.Web.Page.ForumController do
  use KuikkaWebsite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _params) do
    render conn, "show.html"
  end

  def create(conn, _params) do
    render conn, "show.html"
  end

  def update(conn, _params) do
    render conn, "show.html"
  end
end
