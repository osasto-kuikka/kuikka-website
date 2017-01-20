defmodule KuikkaDB.Schema.RolePermission do
  @moduledoc """
  A module providing tables for role permission:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for role permissions.
  Please see rolePermission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "role_permission" do
    belongs_to :role, KuikkaDB.Schema.Role
    belongs_to :permission, KuikkaDB.Schema.Permission
  end

  @required [:role_id, :permission_id]

  @doc """
  Validate changes to role permission
  """
  @spec changeset(Ecto.Schema.t, Map.t) :: Ecto.Changeset.t
  def changeset(role_permission, params) do
    role_permission
    |> cast(params, @required)
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:permission_id)
  end
end
