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

  alias KuikkaDB.Schema

  schema "role_permission" do
    belongs_to :role, Schema.Role
    belongs_to :permission, Schema.Permission
  end

  @doc """
  Used automatically by ecto many_to_many!
  """
  def changeset(role_permission, params) do
    role_permission
    |> cast(params, [:role_id, :permission_id])
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:permission_id)
  end
end
