defmodule KuikkaDB.Schema.Fireteam do
    use Ecto.Schema
    
    schema "fireteam" do
        field :name, :string
        field :description, :string        
    end
end