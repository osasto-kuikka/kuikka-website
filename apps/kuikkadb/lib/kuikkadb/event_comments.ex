defmodule KuikkaDB.EventComments do
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
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :event_comments

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :event_comments

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :event_comments

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :event_comments
end
