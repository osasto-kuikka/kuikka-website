defmodule KuikkaWebsite.Web.Page.ForumController do
  use KuikkaWebsite.Web, :controller
  import Ecto.Query

  alias KuikkaWebsite.Forum.Topic
  alias KuikkaWebsite.Repo

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, %{"view" => "new", "title" => title}) do
    conn
    |> assign(:changeset, Topic.changeset(%Topic{}, %{title: title}))
    |> render("new.html")
  end
  def index(conn, %{"view" => "new"}) do
    conn
    |> assign(:changeset, Topic.changeset(%Topic{}))
    |> render("new.html")
  end
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, %{"id" => title, "view" => "edit"}) do
    Topic
    |> where([t], t.title == ^title)
    |> Repo.one()
    |> case do
      nil ->
        redirect(conn, to: forum_path(conn, :index, %{view: "new", title: title}))
      topic ->
        conn
        |> assign(:changeset, Topic.changeset(topic))
        |> render("edit.html")
    end
  end
  def show(conn, %{"id" => title}) do
    Topic
    |> where([t], t.title == ^title)
    |> Repo.one()
    |> case do
      nil ->
        redirect(conn, to: forum_path(conn, :index, %{view: "new", title: title}))
      topic ->
        conn
        |> assign(:page, topic)
        |> render("show.html")
    end
  end
  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, %{"topic" => params}) do
    %Topic{}
    |> Topic.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, topic} ->
        redirect(conn, to: forum_path(conn, :show, topic.title))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
  def update(conn, _params) do
    render conn, "show.html"
  end
end
