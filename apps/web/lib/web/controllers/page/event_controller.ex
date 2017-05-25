defmodule Web.Page.EventController do
  use Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.{Repo, EventSchema}

  @doc """
  Show event list or editor to create new event
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"new_event" => "true"}) do
    conn
    |> assign(:path, event_path(conn, :create))
    |> assign(:changeset, EventSchema.changeset(%EventSchema{}))
    |> render("event-editor.html")
  end
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Show event or update old event in editor
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, _params) do
    render(conn, "show.html")
  end

  @doc """
  Create or update event page
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"event" => event}) do
    %EventSchema{}
    |> EventSchema.changeset(event) |> IO.inspect
    |> Repo.insert()
    |> case do
      {:ok, event} ->
        redirect(conn, to: event_path(conn, :show, event.id))
      {:error, changeset} ->
        conn
        |> assign(:path, event_path(conn, :create))
        |> assign(:changeset, changeset)
        |> render("event-editor.html")
    end
  end
end
