defmodule Kuikka.Web.EventController do
  use Kuikka.Web, :controller

  @require_user [:new, :edit, :create, :update, :update_comment]
  plug :require_user when action in @require_user

  @doc """
  Show all events

  ## Route
  ```
  get /events
  ```
  """
  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    events =
      Event
      |> preload(:comments)
      |> Repo.all()

    conn
    |> assign(:events, events)
    |> render("events.html")
  end

  @doc """
  Add new event

  ## Route
  ```
  get /events/new
  ```
  """
  @spec new(Plug.Conn.t, map) :: Plug.Conn.t
  def new(conn, _params) do
    conn
    |> assign(:changeset, Event.changeset(%Event{}))
    |> render("new.html")
  end

  @doc """
  Show single event

  ## Route
  ```
  get /events/:id
  ```
  """
  @spec event(Plug.Conn.t, map) :: Plug.Conn.t
  def event(conn, %{"id" => id}) do
    Event
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "event not found")
        |> put_status(404)
        |> redirect(to: event_path(conn, :index))
      event ->
        conn
        |> assign(:event, event)
        |> render("event.html")
    end
  end

  @doc """
  Edit single event

  ## Route
  ```
  get /events/:id/edit
  ```
  """
  @spec edit(Plug.Conn.t, map) :: Plug.Conn.t
  def edit(conn, %{"id" => id, "edit" => "true"}) do
    Event
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "event not found")
        |> put_status(404)
        |> redirect(to: event_path(conn, :index))
      event ->
        conn
        |> assign(:changeset, Event.changeset(event))
        |> render("edit.html")
    end
  end

  @doc """
  Post new events

  ## Route
  ```
  post /events
  ```
  """
  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, _params) do
    # TODO
    render conn, "show.html"
  end

  @doc """
  Post new comment to event

  ## Route
  ```
  post /events/:id
  ```
  """
  @spec create_comment(Plug.Conn.t, map) :: Plug.Conn.t
  def create_comment(conn, _params) do
    # TODO
    render conn, "show.html"
  end

  @doc """
  Update event

  ## Route
  ```
  put /events/:id
  ```
  """
  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
  def update(conn, _params) do
    # TODO
    render conn, "show.html"
  end

  @doc """
  Update event comment

  ## Route
  ```
  put /events/:id/:comment_id
  ```
  """
  @spec update_comment(Plug.Conn.t, map) :: Plug.Conn.t
  def update_comment(conn, %{"id" => _id, "comment_id" => _comment_id}) do
    # TODO
    render conn, "show.html"
  end
end
