defmodule Web.Page.ForumController do
  @moduledoc """
  Controller for forums
  """
  use Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.{Repo, TopicSchema, CommentSchema}

  @doc """
  Show all forum topics
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"new_topic" => "true"}) do
    conn
    |> assign(:path, forum_path(conn, :create))
    |> assign(:changeset, TopicSchema.changeset(%TopicSchema{}))
    |> render("topic-editor.html")
  end
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Show single forum topic with all comments
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id, "comment" => comment}) do
    comment = Repo.get(CommentSchema, comment)

    conn
    |> assign(:path, forum_path(conn, :update, id))
    |> assign(:changeset, CommentSchema.changeset(comment))
    |> render("comment-editor.html")
  end
  def show(conn, %{"id" => id, "edit" => "true"}) do
    topic = Repo.get(TopicSchema, id)

    conn
    |> assign(:path, forum_path(conn, :update, id))
    |> assign(:changeset, TopicSchema.changeset(topic))
    |> render("topic-editor.html")
  end
  def show(conn, _params) do
    render(conn, "show.html")
  end

  @doc """
  Create new topic
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"topic" => topic_params}) do
    case Forum.create_topic(conn.assigns.current_user, topic_params) do
      {:ok, topic} ->
        redirect(conn, to: forum_path(conn, :show, topic.id))
      {:error, changeset} ->
        {field, {message, _}} = Enum.at(changeset.errors, 0)
        conn
        |> put_flash(:error, "#{field}: " <> message)
        |> assign(:changeset, changeset)
        |> render("topic-editor.html")
    end
  end

  @doc """
  Update topic information or send new comments
  """
  @spec update(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def update(conn, %{"id" => id, "comment" => comment = %{"id" => c_id}}) do
    CommentSchema
    |> Repo.get(c_id)
    |> CommentSchema.changeset(comment)
    |> Repo.update()
    |> case do
      {:ok, _} ->
        redirect(conn, to: forum_path(conn, :show, id))
      {:error, changeset} ->
        {field, {message, _}} = Enum.at(changeset.errors, 0)
        conn
        |> put_flash(:error, "#{field}: " <> message)
        |> assign(:changeset, changeset)
        |> render("comment-editor.html")
    end
  end
  def update(conn, %{"id" => id, "comment" => comment}) do
    comment = Map.put(comment, "user", conn.assigns.current_user)

    TopicSchema
    |> preload([:comments])
    |> where([t], t.id == ^id)
    |> Repo.one()
    |> case do
      nil ->
        conn
        |> put_flash(:error, "Failed to find topic")
        |> assign(:path, forum_path(conn, :update, id))
        |> assign(:changeset, CommentSchema.changeset(comment))
        |> render("comment-editor.html")
      topic ->
        %CommentSchema{}
        |> CommentSchema.changeset(comment)
        |> Repo.insert()
        |> case do
          {:ok, comment} ->
            topic
            |> TopicSchema.changeset(%{comment: comment})
            |> Repo.update!()

            redirect(conn, to: forum_path(conn, :show, id))
          {:error, changeset} ->
            conn
            |> assign(:path, forum_path(conn, :update, id))
            |> assign(:changeset, changeset)
            |> render("comment-editor.html")
        end
    end
  end
end
