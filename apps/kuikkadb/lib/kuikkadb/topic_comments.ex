defmodule KuikkaDB.TopicComments do
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
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :topic_comments

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :topic_comments

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :topic_comments

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :topic_comments
end
