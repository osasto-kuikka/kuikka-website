defmodule KuikkaDB.Schema.TopicComment do
  @moduledoc """
  Database schema for topic_comment table
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic_comment" do
    belongs_to :topic, KuikkaDB.Schema.Topic
    belongs_to :comment, KuikkaDB.Schema.Comment
  end

  @required [:topic_id, :comment_id]

  @doc """
  Validate changes to role permission
  """
  @spec changeset(Ecto.Schema.t, Map.t) :: Ecto.Changeset.t
  def changeset(topic_comment, params) do
    topic_comment
    |> cast(params, @required)
    |> foreign_key_constraint(:topic_id)
    |> foreign_key_constraint(:comment_id)
  end
end
