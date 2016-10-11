defmodule KuikkaDB.Schema.Fireteam do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)
  
  This Schema and changeset is for fireteams. Please see fireteam table for further details.
  """
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "fireteam" do
        field :name, :string
        field :description, :string        
    end
    def changeset(fireteam, params \\ %{}) do
        fireteam
        |> cast(params, [:name,:description])
        |> validate_required([:name])
        |> unique_constraint(:name)       
    end
end