defmodule Forum do
  @moduledoc """
  Documentation for Forum.
  """
  import Ecto.Query

  alias KuikkaDB.{Repo, TopicSchema, CategorySchema, CommentSchema}
  alias Ecto.Changeset

  @type topic_id :: integer | String.t

  @doc """
  Create new topic with params from frontend controller
  """
  @spec create_topic(UserSchema.t, Map.t) :: TopicSchema.return
  def create_topic(user, topic) do
    category = Repo.get_by!(CategorySchema, name: "Uncategorized")
    %TopicSchema{}
    |> TopicSchema.changeset(%{
      title: topic["title"],
      content: topic["content"]
    })
    |> Changeset.put_assoc(:user, user)
    |> Changeset.put_assoc(:category, category)
    |> Repo.insert()
  end

  @doc """
  Add comment to topic
  """
  @spec add_comment(UserSchema.t, topic_id, Map.t) :: CommentSchema.return
  def add_comment(user, topic_id, comment) do
    %CommentSchema{}
    |> CommentSchema.changeset(%{
      content: comment["content"]
    })
    |> Changeset.put_assoc(:user, user)
    |> Repo.insert()
    |> case do
      {:ok, comment} ->
         topic =
           TopicSchema
           |> where([t], t.id == ^topic_id)
           |> preload(:comments)
           |> Repo.one()
        topic
         |> TopicSchema.changeset(%{})
         |> Changeset.put_assoc(:comments, Enum.into(topic.comments, [comment]))
         |> Repo.update()
      tuple ->
        tuple
    end
  end
end
