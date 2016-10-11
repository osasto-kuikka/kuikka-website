defmodule KuikkaDB.Schema.Permission do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "permission" do
        field :name, :string
        field :description, :string        
    end
    def changeset(permission, params \\%{}) do
        permission
        |> cast(params, [:name,:description])
        |> validate_required([:name])       
    end
end