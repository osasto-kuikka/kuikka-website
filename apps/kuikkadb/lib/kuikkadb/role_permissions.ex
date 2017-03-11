defmodule KuikkaDB.RolePermissions do
  @moduledoc """
  ## Table
  ```
  :role_id, references(:roles), null: false
  :permission_id, references(:permissions), null: false
  ```

  ## Index
  ```
  index(:role_permissions, [:role_id, :permission_id], unique: true)
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :role_permissions

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :role_permissions

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :role_permissions

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :role_permissions

end
