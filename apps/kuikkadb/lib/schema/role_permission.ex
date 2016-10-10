defmodule KuikkaDB.Schema.RolePermission do
    use Ecto.Schema
    
    schema "role_permission" do
        belongs_to :role_id, KuikkaDB.Schema.Role
        belongs_to :permission_id, KuikkaDB.Schema.Permission
        field :name, :string
        field :description, :string    
    end
end