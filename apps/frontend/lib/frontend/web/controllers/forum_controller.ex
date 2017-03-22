defmodule Frontend.Page.ForumController do
  @moduledoc """
  Controller for forums
  """
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.Topics
  alias KuikkaDB.Categories
  alias KuikkaDB.Comments
  alias KuikkaDB.TopicComments
  alias Steamex.Profile
  alias Frontend.Utils

  @doc """
  Show all forum topics
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"editor" => "true"}) do
    if Utils.has_permission?(conn, "create_forum_post") do
      case Categories.all() do
        {:ok, categories} ->
          conn
          |> assign(:categories, Enum.map(categories, &{&1.name, &1.id}))
          |> render("editor.html")
          {:error, msg} ->
            conn
            |> put_flash(:error, msg)
            |> redirect(to: forum_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "You don't have permission to create forum posts")
      |> redirect(to: home_path(conn, :index))
    end
  end
  def index(conn, _params) do
    if Utils.has_permission?(conn, "read_forum") do
      case Topics.topic_list() do
        {:ok, topics} ->
          conn
          |> assign(:topics, Enum.map(topics, &profile_to_user(&1)))
          |> render("topic_list.html")
          {:error, msg} ->
            conn
            |> put_flash(:error, msg)
            |> assign(:topics, [])
            |> render("topic_list.html")
     end
   else
      conn
      |> put_flash(:error, "You don't have permission to see forums")
      |> redirect(to: home_path(conn, :index))
   end
  end

  @doc """
  Show single forum topic with all comments
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    if Utils.has_permission?(conn, "read_forum") do
      with {id, ""} <- Integer.parse(id),
          {:ok, [topic]} <- Topics.get_topic(id),
          {:ok, comments} <- Comments.topic_comments(id)
          do
        conn
        |> assign(:topic, profile_to_user(topic))
        |> assign(:comments, Enum.map(comments, &profile_to_user(&1)))
        |> render("topic.html")
      else
        _ ->
          conn
          |> put_flash(:error, dgettext("forum", "Failed to find topic"))
          |> redirect(to: forum_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, dgettext("forum", "You don't have permission to see topics"))
      |> redirect(to: home_path(conn, :index))
  end
end

  @doc """
  Create new topic or comment
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"topic" => %{"title" => title, "text" => text,
                                  "category" => category}}) do
    if Utils.has_permission?(conn, "create_forum_post") do
      [
        title: title,
        text: text,
        category_id: String.to_integer(category),
        user_id: conn.assigns.user.id
      ]
      |> Topics.insert()
      |> case do
        {:ok, [topic]} ->
          conn
          |> put_flash(:info, dgettext("forum", "New topic created"))
          |> redirect(to: forum_path(conn, :show, topic.id))
          {:error, msg} ->
            conn
            |> put_flash(:error, msg)
            |> redirect(to: forum_path(conn, :index, %{"editor" => "true"}))
      end
    else
      conn
      |> put_flash(:error, dgettext("forum", "You don't have permission to create topics"))
      |> redirect(to: home_path(conn, :index))
   end
  end
  def create(conn, %{"comment" => %{"topic" => topic, "text" => text}}) do
    if Utils.has_permission?(conn, "create_topic_comment") do
      user = conn.assigns.user

      with {topic, ""} <- Integer.parse(topic),
          {:ok, [c]} <- Comments.insert(text: text, user_id: user.id),
          {:ok, _} <- TopicComments.insert(topic_id: topic, comment_id: c.id)
      do
        conn
        |> put_flash(:info, dgettext("forum", "New comment added"))
        |> redirect(to: forum_path(conn, :show, topic))
      else
        {:error, msg} ->
          conn
          |> put_flash(:error, msg)
          |> redirect(to: forum_path(conn, :show, topic))
      _   ->
          conn
          |> put_flash(:error, dgettext("forum", "Failed to create comment"))
          |> redirect(to: forum_path(conn, :show, topic))
        end
      else
        conn
        |> put_flash(:error, dgettext("forum", "You don't have permission to comment topics"))
        |> redirect(to: home_path(conn, :index))
      end
  end

  @spec profile_to_user(Map.t) :: Map.t
  defp profile_to_user(map) do
    steamid = Decimal.to_integer(Map.get(map, :user))
    Map.put(map, :profile, Profile.fetch(steamid))
  end
end
