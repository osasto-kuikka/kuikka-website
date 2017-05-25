defmodule KuikkaDB.EventCommentSchema do
  @moduledoc """
  ## Table
  ```
  :event_id, references(:events), null: false
  :comment_id, references(:comments), null: false
  ```

  ## Index
  ```
  index(:event_comments, [:event_id, :comment_id], unique: true)
  ```
  """
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "event_comments" do
    belongs_to :event_schema_id, KuikkaDB.EventSchema
    belongs_to :comment_schema_id, KuikkaDB.CommentSchema
  end
end
