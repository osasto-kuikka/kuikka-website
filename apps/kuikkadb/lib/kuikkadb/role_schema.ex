defmodule KuikkaDB.RoleSchema do
  @moduledoc """
  ## Table
  ```
  :name, :string, size: 50, null: false
  :description, :string, size: 250, null: true
  ```

  ## Index
  ```
  index(:roles, [:name], unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "roles" do
    field :name, :string
    field :description, :string
    many_to_many :permissions, KuikkaDB.PermissionSchema,
                 join_through: "role_permissions"
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:name, :description])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 1, max: 50)
    |> validate_length(:description, min: 1, max: 250)
  end
end
