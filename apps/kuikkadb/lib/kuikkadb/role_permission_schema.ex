defmodule KuikkaDB.RolePermissionSchema do
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
  use Ecto.Schema

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "role_permissions" do
    belongs_to :role, KuikkaDB.RoleSchema
    belongs_to :permission, KuikkaDB.PermissionSchema
  end
end
