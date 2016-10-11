defmodule KuikkaDB.Schema.Fireteamrole do
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "fireteamrole" do
        field :name, :string
        field :description, :string 
        field :is_leader, :boolean       
    end
    def changeset(fireteamrole, params \\ %{}) do
        fireteamrole
        |> cast(params, [:name, :description,:is_leader])
        |> validate_required([:name, :is_leader])
        |> unique_constraint([:name])
        
    end    
end