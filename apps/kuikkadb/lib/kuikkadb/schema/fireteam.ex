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
    has_many :users, KuikkaDB.Schema.User
  end

  @doc """
  Generate changeset to update or insert row to fireteam

  ## Examples

      iex> KuikkaDB.Schema.Fireteam.changeset(%KuikkaDB.Schema.Fireteam{},
                                              %{name: "No group"})
  """
  def changeset(fireteam, params) when is_map(params) do
    fireteam
    |> cast(params, [:name,:description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
