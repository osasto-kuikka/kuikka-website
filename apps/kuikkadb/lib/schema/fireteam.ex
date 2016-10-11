defmodule KuikkaDB.Schema.Fireteam do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "fireteam" do
        field :name, :string
        field :description, :string        
    end
    def changeset(fireteam, params \\%{}) do
        fireteam
        |> cast(params, [:name,:description])
        |> validate_required([:name])       
    end
end