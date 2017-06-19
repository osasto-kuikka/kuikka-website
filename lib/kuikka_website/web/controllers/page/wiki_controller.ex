defmodule KuikkaWebsite.Web.Page.WikiController do
  use KuikkaWebsite.Web, :controller
  import Ecto.Query

  alias KuikkaWebsite.Wiki
  alias KuikkaWebsite.Repo

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, %{"view" => "new", "title" => title}) do
    conn
    |> assign(:changeset, Wiki.changeset(%Wiki{}, %{title: title}))
    |> render("new.html")
  end
  def index(conn, %{"view" => "new"}) do
    conn
    |> assign(:changeset, Wiki.changeset(%Wiki{}))
    |> render("new.html")
  end
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, %{"id" => title, "view" => "edit"}) do
    Wiki
    |> where([w], w.title == ^title)
    |> Repo.one()
    |> case do
      nil ->
        redirect(conn, to: wiki_path(conn, :index, %{view: "new", title: title}))
      wiki ->
        conn
        |> assign(:changeset, Wiki.changeset(wiki))
        |> render("edit.html")
    end
  end
  def show(conn, %{"id" => title}) do
    Wiki
    |> where([w], w.title == ^title)
    |> Repo.one()
    |> case do
      nil ->
        redirect(conn, to: wiki_path(conn, :index, %{view: "new", title: title}))
      wiki ->
        conn
        |> assign(:page, wiki)
        |> render("show.html")
    end
  end

  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, %{"wiki" => params}) do
    %Wiki{}
    |> Wiki.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, wiki} ->
        redirect(conn, to: wiki_path(conn, :show, wiki.title))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
  def update(conn, %{"id" => title, "wiki" => params}) do
    Wiki
    |> where([w], w.title == ^title)
    |> Repo.one()
    |> case do
      nil ->
        redirect(conn, to: wiki_path(conn, :index, %{view: "new", title: title}))
      wiki ->
        wiki
        |> Wiki.changeset(params)
        |> Repo.update()
        |> case do
          {:ok, wiki} ->
            redirect(conn, to: wiki_path(conn, :show, wiki.title))
          {:error, changeset} ->
            conn
            |> assign(:changeset, changeset)
            |> render("new.html")
        end
    end
  end
end
