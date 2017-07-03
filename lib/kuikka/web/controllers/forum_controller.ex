defmodule Kuikka.Web.ForumController do
  use Kuikka.Web, :controller

  alias Kuikka.Forum.Topic
  alias Kuikka.Repo

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, _params) do
    render conn, "show.html"
  end

  @spec new(Plug.Conn.t, map) :: Plug.Conn.t
  def new(conn, _params) do
    conn
    |> assign(:changeset, Topic.changeset(%Topic{}))
    |> render("new.html")
  end

  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, _params) do
    render conn, "show.html"
  end

  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
  def update(conn, _params) do
    render conn, "show.html"
  end
end
