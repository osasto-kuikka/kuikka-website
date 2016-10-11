defmodule KuikkaDB.Schema.Role do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "role" do
       # korvaa many to many belongs_to :role_permission_id, KuikkaDB.Schema.Role_permission
        field :name, :string
        field :description, :string    
    end
    def changeset(role, params \\  %{}) do
        role
        |> cast(params, [:name,:description, :role_permission_id])
        |> validate_required([:name])
        |> foreing_key_constrait([:role_permission_id])
        |> unique_constraint([:name, :role_permission_id])            
    end
end