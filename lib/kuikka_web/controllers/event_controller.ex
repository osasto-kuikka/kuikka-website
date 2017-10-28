defmodule KuikkaWeb.EventController do
  use KuikkaWeb, :controller
  require Logger

  alias Event.Comment

  # Check that user is logged in
  plug :require_user, [] when action in [:new, :edit, :create, :update,
                                        :update_comment, :delete_comment]

  # Check that id is integer
  plug :param_check, [type: :integer]
    when action in [:event, :update, :update_comment, :delete_comment]

  # Check that comment_id is integer
  plug :param_check, [param: "comment_id", type: :integer]
    when action in [:update_comment, :delete_comment]

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
      |> preload([:comments, :attending])
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
    |> preload([:attending, :creator, :modified, comments: [:member]])
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "event not found")
        |> redirect(to: event_path(conn, :index))
      event ->
        conn
        |> assign(:changeset, Comment.changeset(%Comment{}))
        |> assign(:event, event)
        |> render("event.html")
    end
  end

  @doc """
  Attend to event

  ## Route
  ```
  get /events/:id/attend
  ```
  """
  @spec attend(Plug.Conn.t, map) :: Plug.Conn.t
  def attend(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    Event
    |> preload([:attending, :creator, :modified])
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "event not found")
        |> redirect(to: event_path(conn, :index))
      event ->
        event
        |> Event.changeset(%{attending: [user | event.attending]})
        |> Repo.update!()

        redirect(conn, to: event_path(conn, :event, id))
    end
  end

  @doc """
  Unattend from event

  ## Route
  ```
  get /events/:id/unattend
  ```
  """
  @spec unattend(Plug.Conn.t, map) :: Plug.Conn.t
  def unattend(conn, %{"id" => id}) do
    user = conn.assigns.current_user
    Event
    |> preload([:attending, :creator, :modified])
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
         nil ->
           conn
           |> put_flash(:error, "event not found")
           |> redirect(to: event_path(conn, :index))
         event ->
           attending =  Enum.reject(event.attending, &(&1.id == user.id))
           event
           |> Event.changeset(%{attending: attending})
           |> Repo.update!()

           redirect(conn, to: event_path(conn, :event, id))
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
  def create(conn, %{"event" => params}) do
    user = conn.assigns.current_user
    %Event{}
    |> Event.changeset(Map.put(params, "creator", user))
    |> Repo.insert()
    |> case do
      {:ok, event} ->
        conn
        |> put_flash(:info, "new event created")
        |> redirect(to: event_path(conn, :event, event.id))
      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("new.html")
    end
  end

  @doc """
  Post new comment to event

  ## Route
  ```
  post /events/:id
  ```
  """
  @spec create_comment(Plug.Conn.t, map) :: Plug.Conn.t
  def create_comment(conn, %{"id" => id, "comment" => comment}) do
    user = conn.assigns.current_user
    Event
    |> preload([:comments])
    |> where([e], e.id == ^id)
    |> Repo.one()
    |> case do
      nil -> nil
      event ->
        params =
          comment
          |> Map.put("event", event)
          |> Map.put("member", user)
        # Event found so try to insert comment
        %Comment{}
        |> Comment.changeset(params)
        |> Repo.insert()
    end
    |> case do
      nil ->
        # Failed to find event
        conn
        |> put_flash(:error, "event not found")
        |> redirect(to: event_path(conn, :index))
      {:ok, _comment} ->
        # Comment inserted succefully
        conn
        |> put_flash(:info, "new comment added")
        |> redirect(to: event_path(conn, :event, id))
      {:error, changeset} ->
        # Failed to insert comment
        conn
        |> put_flash(:error, "failed to add comment")
        |> assign(:comment, changeset.data.content)
        |> redirect(to: event_path(conn, :event, id))
    end
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

  @doc """
  Delete event comment

  ## Route
  ```
  put /events/:id/:comment_id
  ```
  """
  @spec delete_comment(Plug.Conn.t, map) :: Plug.Conn.t
  def delete_comment(conn, %{"id" => id, "comment_id" => comment_id}) do
    Comment
    |> where([c], c.id == ^comment_id)
    |> Repo.one()
    |> case do
      nil -> nil
      comment -> Repo.delete(comment)
    end
    |> case do
      nil ->
        # Comment not found
        conn
        |> put_flash(:error, "comment not found")
        |> redirect(to: event_path(conn, :event, id))
      {:ok, _} ->
        # Comment deleted succefully
        conn
        |> put_flash(:info, "comment deleted")
        |> redirect(to: event_path(conn, :event, id))
      {:error, err} ->
        # Failed to delete comment
        :ok = Logger.error("#{__MODULE__}: #{inspect err}")

        conn
        |> put_flash(:error, "failed to delete comment")
        |> redirect(to: event_path(conn, :event, id))
    end
  end
end
