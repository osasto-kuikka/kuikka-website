defmodule KuikkaDB.Comments do
  @moduledoc """
  ## Table
  ```
  :text, :string, size: 2500, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :user_id, references(:users), null: false
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :comments

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :comments

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :comments

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :comments

  @doc """
  Get all comments for topic
  """
  @spec topic_comments(integer) :: {:ok, List.t} | {:error, String.t}
  defquery topic_comments(topic_id) do
    """
    select
      c.id,
      c.text,
      c.createtime,
      u.id as user_id,
      u.steamid as user
    from comments c
    inner join users u on u.id = c.user_id
    inner join topic_comments tc
      on tc.topic_id = $topic_id::integer
      and tc.comment_id = c.id
    """
  end
end
