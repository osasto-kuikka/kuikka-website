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
end
