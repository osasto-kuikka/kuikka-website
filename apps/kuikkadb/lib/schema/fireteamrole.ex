defmodule KuikkaDB.Schema.Fireteamrole do
  @moduledoc """
  A module providing tables
  by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for fireteam roles.
  Please see fireteamrole table for further details.
  """
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
