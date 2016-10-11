defmodule KuikkaDB.Schema.RolePermission do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "role_permission" do
        belongs_to :role_id, KuikkaDB.Schema.Role
        belongs_to :permission_id, KuikkaDB.Schema.Permission
        field :name, :string
        field :description, :string    
    end
    def changeset(permission, params \\%{}) do
        permission
        |> cast(params, [:name,:description])
        |> validate_required([:name])
        |> foreing_key_constrait([:role_id,:role_permission])       
    end
end