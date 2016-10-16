defmodule KuikkaDB.Schema.RolePermission do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for role's permissions. Please see rolePermission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Schema

  schema "role_permission" do
      belongs_to :role, Schema.Role
      belongs_to :permission, Schema.Permission
  end

  @doc """
  Generate changeset to update or insert row to role_permission

  ## Examples

      iex> KuikkaDB.Schema.RolePermission.changeset(
                                      %KuikkaDB.Schema.RolePermission{},
                                      %{role_id: 0, permission_id: 0})
  """
  def changeset(role_permission, params) when is_map(params) do
      role_permission
      |> cast(params, [:role_id, :permission_id])
      |> cast_assoc(:role, required: true)
      |> cast_assoc(:permission, required: true)
      |> assoc_constraint(:role)
      |> assoc_constraint(:permission)
    #  |> unique_constraint(:role_id)
    #  |> unique_constraint(:permission_id)
  end
end
