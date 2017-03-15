defmodule Frontend.Page.EventController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.Comments
  alias KuikkaDB.EventComments
  alias KuikkaDB.Events
  alias Steamex.Profile
  alias Frontend.Utils
  @doc """
  Show event list or editor to create new event
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"editor" => "true"}) do
    user = conn.assign(:profile, profile_to_user(profile))
      case Utils.has_permission?(user.id, "create_event") do
        true ->
          conn
          |> assign(:type, :create)
          |> assign(:event, nil)
          |> assign(:title, "")
          |> assign(:time, Timex.now())
          |> assign(:content, "")
          |> render("editor.html")
        false ->
          conn
          |> put_flash(:error, dgettext("event", "You don't have the rights to create events"))
          |> redirect(to: home_path(conn, :index))
        _->
          conn
          |> put_flash(:error, dgettext("event", "Something went wrong."))
          |> redirect(to: home_path(conn, :index))

      end
  end
  def index(conn, _params) do
    case Events.event_list() do
      {:ok, events} ->
        conn
        |> assign(:events, events)
        |> render("event_list.html")
      {:error, _} ->
        conn
        |> put_flash(:error, dgettext("event", "Failed to load event list"))
        |> redirect(to: home_path(conn, :index))
    end
  end

  @doc """
  Show event or update old event in editor
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => event, "editor" => "true"}) do
      with {eventid, ""} <- Integer.parse(event),
          {:ok, [event]} <- Events.get(id: eventid)
          do
            conn
            |> assign(:type, :update)
            |> assign(:event, eventid)
            |> assign(:title, event.title)
            |> assign(:content, event.content)
            |> assign(:time, event.date)
            |> render("editor.html")
          else
            _ ->
              conn
              |> redirect(to: event_path(conn, :index))
              |> put_flash(:error, dgettext("event", "Failed to load editor"))
         end
     end
  def show(conn, %{"id" => event}) do
    with {event, ""} <- Integer.parse(event),
         {:ok, [event]} <- Events.get(id: event),
         {:ok, comments} <- Comments.event_comments(event.id)
    do
      conn
      |> assign(:event, event)
      |> assign(:comments, Enum.map(comments, &profile_to_user(&1)))
      |> render("event.html")
    else
      {:error, msg} when is_binary(msg) ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: event_path(conn, :index))
      _ ->
        conn
        |> put_flash(:error, dgettext("event", "Invalid event url"))
        |> redirect(to: event_path(conn, :index))
    end
  end

  @doc """
  Create or update wiki page
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"event" => %{"title" => title,
                                  "text" => text,
                                  "event" => event,
                                  "time" => time}}) do
    time = to_datetime(time)
    with {event, ""} <- Integer.parse(event),
         {:ok, _} <- Events.update([title: title, content: text, date: time],
                                   [id: event])
    do
      conn
      |> put_flash(:info, dgettext("event", "Event updated"))
      |> redirect(to: event_path(conn, :show, event))
    else
      _ ->
        conn
        |> put_flash(:error, dgettext("event", "Failed to update event"))
        |> redirect(to: event_path(conn, :show, event, %{"editor" => "true"}))
    end
  end
  def create(conn, %{"event" => %{"title" => title, "time" => time,
                                  "text" => text}}) do
    time = to_datetime(time)

    with {:ok, [%{id: e_id}]} <- Events.insert(title: title, content: text,
                                              date: time)
    do
      conn
      |> put_flash(:info, dgettext("event", "New event created"))
      |> redirect(to: event_path(conn, :show, e_id))
    else
      _ ->
        conn
        |> put_flash(:error, dgettext("event", "Failed create event"))
        |> redirect(to: event_path(conn, :index, %{"editor" => "true"}))
    end
  end
  def create(conn, %{"comment" => %{"event" => event,
                                    "text" => text}}) do
    u_id = conn.assigns.user.id

    with {event, ""} <- Integer.parse(event),
         {:ok, [%{id: c_id}]} <- Comments.insert(text: text, user_id: u_id),
         {:ok, _} <- EventComments.insert(event_id: event, comment_id: c_id)
    do
      conn
      |> put_flash(:info, dgettext("event", "Comment added succesfully"))
      |> redirect(to: event_path(conn, :show, event))
    else
      _ ->
        conn
        |> put_flash(:error, dgettext("event", "Failed to add comment"))
        |> redirect(to: event_path(conn, :show, event))
    end
  end

  @spec profile_to_user(Map.t) :: Map.t
  defp profile_to_user(map) do
    steamid = Decimal.to_integer(Map.get(map, :user))
    Map.put(map, :profile, Profile.fetch(steamid))
  end

  @spec to_datetime(Map.t) :: DateTime.t
  def to_datetime(%{"year" => y, "month" => m, "day" => d,
                    "hour" => h, "minute" => min}) do
    Timex.to_datetime(%{year: y, month: m, day: d, hour: h, minute: min})
  end
end
