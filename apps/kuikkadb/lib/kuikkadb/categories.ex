defmodule KuikkaDB.Categories do
  @moduledoc """
  ## Table
  ```
  :name, :string, size: 50, null: false
  :description, :string, size: 255, null: false
  :color, :string, size: 6, null: false
  ```

  ## Index
  ```
  index(:categories, :name, unique: true)
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :categories

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :categories

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :categories

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :categories

  @doc """
  Get all categories
  """
  @spec all() :: {:ok, [%{id: integer, name: String.t}]} | {:error, String.t}
  defquery all() do
    """
    select name, id from categories
    """
  end
end
