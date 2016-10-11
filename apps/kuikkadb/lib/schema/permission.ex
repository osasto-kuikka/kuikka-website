defmodule KuikkaDB.Schema.Permission do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "permission" do
        field :name, :string
        field :description, :string 
        many to many  :role_permission_id, joins_through: KuikkaDB.Schema.RolePermission       
    end
    def changeset(permission, params \\ %{}) do
        permission
        |> cast(params, [:name,:description])
        |> validate_required([:name])
        |> unique_constraint(:name)       
    end
end