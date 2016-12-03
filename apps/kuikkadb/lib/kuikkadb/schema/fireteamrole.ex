defmodule KuikkaDB.Schema.Fireteamrole do
  @moduledoc """
  A module providing tables for fireteamrole:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for fireteam roles.
  Please see fireteamrole table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Repo

  schema "fireteamrole" do
    field :name, :string
    field :description, :string
    field :is_leader, :boolean
    belongs_to :fireteam, KuikkaDB.Schema.Fireteam
    has_many :users, KuikkaDB.Schema.User
  end

  @params [:name, :description, :is_leader, :fireteam_id]
  @required [:name, :is_leader, :fireteam_id]

  def changeset(fireteamrole, params) when is_map(params) do
    fireteamrole
    |> cast(params, @params)
    |> validate_required(@required)
    |> unique_constraint(:name)
  end

  @doc """
  Insert new fireteamrole to database
  """
  def insert(params), do: %__MODULE__{} |> changeset(params) |> Repo.insert

  @doc """
  Update fireteamrole to database
  """
  def update(schema, params), do: schema |> changeset(params) |> Repo.update

  @doc """
  Get one fireteamrole from database
  """
  def one(id: id), do: __MODULE__ |> Repo.get(id) |> one_tuple
  def one(opts), do: __MODULE__ |> Repo.get_by(opts) |> one_tuple
  defp one_tuple(nil), do: {:error, "Failed to find fireteamrole"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all fireteamroles from database
  """
  def all(), do: Repo.all(__MODULE__)
end
