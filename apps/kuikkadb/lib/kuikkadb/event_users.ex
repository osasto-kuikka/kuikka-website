defmodule KuikkaDB.EventUsers do
  @moduledoc """
  ## Table
  ```
  :event_id, references(:event), null: false
  :user_id, references(:users), null: false
  ```

  ## Index
  ```
  index(:event_users, [:event_id, :user_id], unique: true)
  ```
  """
  use Defql

  @doc """
  Get row
  """
  @spec get(Keyword.t) :: {:ok | :error, term}
  defselect get(conds), table: :event_users

  @doc """
  Insert new row
  """
  @spec insert(Keyword.t) :: {:ok | :error, term}
  definsert insert(params), table: :event_users

  @doc """
  Update row
  """
  @spec update(Keyword.t, Keyword.t) :: {:ok | :error, term}
  defupdate update(params, conds), table: :event_users

  @doc """
  Delete row
  """
  @spec delete(Keyword.t) :: {:ok | :error, term}
  defdelete delete(conds), table: :event_users
end
