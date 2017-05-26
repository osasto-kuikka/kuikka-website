defmodule KuikkaWebsite.Member.Permission do
  @moduledoc """

  ## Table
  ```
  :name, :string, size: 50, null: false
  :description, :string, size: 250, null: true
  :no_login, :boolean, default: false, null: false
  ```

  ## Index
  ```
  index(:permissions, [:name], unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "permissions" do
    field :name, :string
    field :description, :string
    field :require_login, :boolean
    many_to_many :roles, KuikkaWebsite.Member.Role,
                                      join_through: "role_permissions"
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params) when is_map(params) do
    schema
    |> cast(params, [:name, :description, :no_login])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 1)
    |> validate_length(:description, min: 1)
  end
end
