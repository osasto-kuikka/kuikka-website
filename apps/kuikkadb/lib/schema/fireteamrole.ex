defmodule KuikkaDB.Schema.fireteamrole do
    use Ecto.Schema
    
    schema fireteamrole do
        field :name, :string
        field :description, :string 
        field :is_leader, :boolean       
    end
end