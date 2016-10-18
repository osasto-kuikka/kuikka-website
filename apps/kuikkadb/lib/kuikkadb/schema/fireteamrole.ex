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
      field :is_leader, :boolean, virtual: true
      has_many :users, KuikkaDB.Schema.User
  end

  @doc """
  Generate changeset to update or insert row to fireteamrole

  ## Examples

      iex> KuikkaDB.Schema.Fireteamrole.changeset(
                                        %KuikkaDB.Schema.Fireteamrole{},
                                        %{name: "Kiväärimies", is_leader: false})
  """
  def changeset(fireteamrole, params) when is_map(params) do
      fireteamrole
      |> cast(params, [:name, :description,:is_leader])
      |> validate_required(:name)
      |> validate_required(:is_leader)
      |> unique_constraint(:name)
  end
end
