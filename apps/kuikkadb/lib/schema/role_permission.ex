defmodule KuikkaDB.Schema.RolePermission do
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