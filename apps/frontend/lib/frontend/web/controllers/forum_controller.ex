defmodule Frontend.Page.ForumController do
  @moduledoc """
  Controller for forums
  """
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.Repo
  alias KuikkaDB.Schema.{Topic, Comment, Category}
  alias KuikkaDB.Schema.User, as: UserSchema

  @doc """
  Show all forum topics
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"editor" => "true"}) do
    categories = Category
                 |> Repo.all()
                 |> Enum.map(&{&1.name, &1.id})
    conn
    |> assign(:categories, categories)
    |> render("editor.html")
  end
  def index(conn, _params) do
    topics = Topic
             |> order_by([t], asc: t.createtime)
             |> preload([:category, :comments, user: [role: :permissions]])
             |> Repo.all()
             |> Enum.map(fn t ->
                  %{t | user: KuikkaDB.user_schema_to_struct(t.user)}
                end)

    conn
    |> assign(:topics, topics)
    |> render("topic_list.html")
  end

  @doc """
  Show single forum topic with all comments
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    c_q = from(c in Comment,
                preload: [user: [role: :permissions]],
                order_by: :createtime)

    Topic
    |> where([t], t.id == ^id)
    |> preload([:category, comments: ^c_q, user: [role: :permissions]])
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, gettext("Failed to find requested topic"))
        |> redirect(to: forum_path(conn, :index))
      topic ->
        conn
        |> assign(:topic, user_struct_to_topic(topic))
        |> render("topic.html")
    end
  end

  @doc """
  Create new topic or comment
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"topic" => %{"title" => title, "text" => text,
                                  "category" => category}}) do
    steamid = conn.assigns.user.profile.steam_id64
    user_id = Repo.get_by(UserSchema, steamid: steamid).id

    %Topic{}
    |> Topic.changeset(%{title: title, text: text, user_id: user_id,
                         category_id: category})
    |> Repo.insert()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("New topic created"))
        |> redirect(to: forum_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Failed to create topic"))
        |> render("new_topic.html")
    end
  end
  def create(conn, %{"comment" => %{"topic" => topic, "text" => text}}) do
    steamid = conn.assigns.user.profile.steam_id64
    user_id = Repo.get_by(UserSchema, steamid: steamid).id

    %Comment{}
    |> Comment.changeset(%{text: text, user_id: user_id})
    |> Repo.insert()
    |> case do
      {:ok, comment} ->
        Topic
        |> Repo.preload(:comments)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:comments, [comment])
        |> Repo.update()
      tuple -> tuple
    end
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, gettext("New comment added"))
        |> redirect(to: forum_path(conn, :show, topic))
      {:error, _} ->
        conn
        |> put_flash(:error, gettext("Failed to add comment"))
        |> redirect(to: forum_path(conn, :show, topic))
    end
  end

  # Add user struct to topic user and comment users
  @spec user_struct_to_topic(Ecto.Schema.t) :: Ecto.Schema.t
  defp user_struct_to_topic(topic) do
    user = KuikkaDB.user_schema_to_struct(topic.user)
    comments = Enum.map(topic.comments, fn c ->
      %{c | user: KuikkaDB.user_schema_to_struct(c.user)}
    end)
    %{topic | user: user, comments: comments}
  end
end
