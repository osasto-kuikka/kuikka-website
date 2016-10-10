defmodule KuikkaDB.Schema.User do
    use Ecto.Schema
    
    schema user do
        field :username, :string
        field :password, :string
        field :email, :string
        field :imageurl, :string
        field :signature, :string
        
    end
end