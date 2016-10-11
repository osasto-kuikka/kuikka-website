defmodule KuikkaDB.Schema.RolePermission do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)
  
  This Schema and changeset is for role's permissions. Please see rolePermission table for further details.
  """  
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "role_permission" do
        belongs_to :role_id, KuikkaDB.Schema.Role
        belongs_to :permission_id, KuikkaDB.Schema.Permission 
    end
    def changeset(role_permission, params \\ %{}) do
        role_permission
        |> cast(params, [role_id, :permission_id])
        |> foreing_key_constrait([:role_id,:permission_id])  
        |> unique_constraint([:name, :role_id, :permission_id])     
    end
end