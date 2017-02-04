defmodule KuikkaDB.Topics do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 255, null: false
  :text, :string, size: 2500, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :user_id, references(:users), null: false
  :category_id, references(:categories), null: false
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :topics

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :topics

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :topics

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :topics

  @doc """
  Get list of topics
  """
  @spec topic_list() :: {:ok, List.t} | {:error, String.t}
  defquery topic_list() do
    """
    select
        t.id
      , t.title
      , t.text
      , ca.name as category
      , ca.color as category_color
      , u.id as user_id
      , u.steamid as user
    from topics t
    inner join users u on t.user_id = u.id
    inner join categories ca on t.category_id = ca.id
    order by t.createtime
    """
  end

  @doc """
  Get topic with user
  """
  @spec get_topic(integer) :: {:ok, List.t} | {:error, String.t}
  defquery get_topic(topic_id) do
    """
    select
      t.id,
      t.title,
      t.text,
      t.user_id,
      t.createtime,
      c.name as category,
      c.color as category_color,
      u.steamid as user
    from topics t
    inner join users u on u.id = t.user_id
    inner join categories c on c.id = t.category_id
    where t.id = $topic_id::integer
    """
  end
end
