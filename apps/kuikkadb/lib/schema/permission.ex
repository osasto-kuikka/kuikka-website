defmodule KuikkaDB.Schema.Permission do
    use Ecto.Schema
    
    schema permission do
        field :name, :string
        field :description, :string        
    end
end