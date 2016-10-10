defmodule KuikkaDB.Schema.Role do
    use Ecto.Schema
    
    schema "role" do
        belongs_to :role_permission_id, KuikkaDB.Schema.Role_permission
        field :name, :string
        field :description, :string    
    end
end