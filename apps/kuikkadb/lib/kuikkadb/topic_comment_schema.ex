defmodule KuikkaDB.TopicCommentSchema do
  @moduledoc """
  ## Table
  ```
  :topic_id, references(:topics), null: false
  :comment_id, references(:comments), null: false
  ```

  ## Index
  ```
  index(:topic_comments, [:topic_id, :comment_id], unique: true)
  ```
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "topic_comments" do
    belongs_to :topic_schema_id, KuikkaDB.TopicSchema
    belongs_to :comment_schema_id, KuikkaDB.CommentSchema
  end
end
