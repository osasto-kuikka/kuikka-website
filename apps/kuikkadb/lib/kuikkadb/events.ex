defmodule KuikkaDB.Events do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 255, null: false
  :content, :string, size: 5000, null: false
  :date, :utc_datetime, null: false
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
  defselect get(conds), table: :events

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :events

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :events

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :events

  @doc """
  Get list of events
  """
  @spec event_list() :: {:ok, List.t} | {:error, String.t}
  defquery event_list() do
    """
    select e.id, e.title, e.content, e.date
    from events e
    order by e.date
    """
  end
end
