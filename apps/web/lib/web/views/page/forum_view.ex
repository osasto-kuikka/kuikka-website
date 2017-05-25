defmodule Web.Page.ForumView do
  use Web, :view
  alias Phoenix.HTML

  alias KuikkaDB.{Repo, TopicSchema}

  @doc """
  Convert markdown to html
  """
  @spec markdown_to_html(binary) :: binary
  def markdown_to_html(markdown) do
    markdown
    |> Earmark.as_html!()
    |> raw
    |> HTML.html_escape()
  end

  @doc """
  Get tab from params
  """
  @spec get_tab(Plug.Conn.t) :: String.t
  def get_tab(conn) do
    case conn.params["tab"] do
      nil -> conn.assigns[:tab] || ""
      val -> val
    end
  end

  @doc """
  Get change from changeset if changeset is in assigns
  """
  @spec get_from_changeset(Plug.Conn.t, atom) :: String.t
  def get_from_changeset(conn, key) do
    case conn.assigns[:changeset] do
      nil -> ""
      changeset -> changeset.changes[key] || ""
    end
  end

  @doc """
  Get change from changeset if changeset is in assigns
  """
  @spec get_from_changeset(Plug.Conn.t, atom) :: String.t
  def get_from_changeset_or_assigns(conn, key) do
    case get_from_changeset(conn, key) do
      "" ->
        case conn.assigns[key] do
          nil -> ""
          val -> val
        end
      val ->
        val
    end
  end

  @doc """
  Get all topics
  """
  @spec get_topics() :: [KuikkaDB.TopicSchema.t]
  def get_topics do
    TopicSchema
    |> preload([:user, :category, :comments])
    |> Repo.all()
  end

  @doc """
  Get topic
  """
  @spec get_topic(Plug.Conn.t) :: TopicSchema.t
  def get_topic(%{params: %{"id" => id}}) do
    TopicSchema
    |> where([t], t.id == ^id)
    |> preload([:user, :category, comments: [:user]])
    |> Repo.one()
    |> case do
      nil -> nil
      topic ->
        %{topic |
          user: User.add_profile(topic.user),
          comments: Enum.map(topic.comments, fn c ->
            %{c | user: User.add_profile(c.user)}
          end)
        }
    end
  end
end
