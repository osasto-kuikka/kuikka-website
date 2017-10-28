defmodule KuikkaWeb.WikiController do
  use KuikkaWeb, :controller
  import Ecto.Query

  alias Kuikka.Wiki
  alias Kuikka.Repo

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec new(Plug.Conn.t, map) :: Plug.Conn.t
  def new(conn, _params) do
    conn
    |> assign(:changeset, Wiki.changeset(%Wiki{}))
    |> render("new.html")
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    Wiki
    |> where([w], w.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "failed to find wiki page")
        |> put_status(404)
        |> redirect(to: wiki_path(conn, :index))
      wiki ->
        conn
        |> assign(:wiki, wiki)
        |> render("show.html")
    end
  end

  @spec edit(Plug.Conn.t, map) :: Plug.Conn.t
  def edit(conn, %{"id" => id}) do
    Wiki
    |> where([w], w.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "failed to find wiki page")
        |> put_status(404)
        |> redirect(to: wiki_path(conn, :index))
      wiki ->
        conn
        |> assign(:changeset, Wiki.changeset(wiki))
        |> render("edit.html")
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
