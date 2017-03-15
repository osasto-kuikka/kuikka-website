defmodule KuikkaDB.Users do
  @moduledoc """
  ## Table
  ```
  :steamid, :decimal, size: 64, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :role_id, references(:roles), null: false
  ```

  ## Index
  ```
  index(:users, :steamid, unique: true)
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :users

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :users

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :users

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :users

  @doc """
  Get all users
  """
  @spec members_list() :: {:ok, List.t} | {:error, String.t}
  defquery members_list() do
    """
    select
      u.id,
      u.steamid,
      u.createtime,
      u.modifytime,
      r.name as role,
      r.description as role_desc
    from users u
    inner join roles r on u.role_id = r.id
    """
  end

  @doc """
  Get single user with role
  """
  @spec get_with_role(String.t | integer) :: {:ok | :error, term}
  defquery get_with_role(steamid) do
    """
    select
      u.id,
      u.steamid,
      u.createtime,
      u.modifytime,
      r.name as role,
      r.description as role_desc
      p.name as permission
    from users u
    inner join roles r on u.role_id = r.id
    inner join role_permissions rp on rp.role_id = r.id
    inner join permissions p on p.id = rp.permission_id
    where u.steamid = $steamid::decimal
    """
  end
end
