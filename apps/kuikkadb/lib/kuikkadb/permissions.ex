defmodule KuikkaDB.Permissions do
  @moduledoc """

  ## Table
  ```
  :name, :string, size: 50, null: false
  :description, :string, size: 250, null: true
  ```

  ## Index
  ```
  index(:permissions, [:name], unique: true)
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :permissions

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :permissions

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :permissions

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :permissions

  @spec get_all() :: {:ok, List.t} | {:error, String.t}
  defquery get_all() do
    "select * from permissions"
  end

  @spec get_reads() :: {:ok, List.t} | { :error, String.t}
  defquery get_reads() do
    """
    select * from permissions p
    where p.name like 'read_%'
    """
  end

  @spec get_no_login() :: {:ok, List.t} | {:error, String.t}
  defquery get_no_login() do
    """
    select name from permissions
    where no_login = true
    """
  end

  @spec get_user(integer) :: {:ok, List.t} | {:error, String.t}
  defquery get_user(user_id) do
    """
    select p.name from permissions p
    inner join users u on u.id = $user_id::integer
    inner join roles r on r.id = u.role_id
    inner join role_permissions rp on rp.role_id = r.id
    where rp.permission_id = p.id
    """
  end
end
