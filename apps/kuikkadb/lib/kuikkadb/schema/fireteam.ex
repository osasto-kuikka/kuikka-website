defmodule KuikkaDB.Schema.Fireteam do
  @moduledoc """
  A module providing tables by using:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for fireteams.
  Please see fireteam table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Repo

  schema "fireteam" do
    field :name, :string
    field :description, :string
    has_many :fireteamroles, KuikkaDB.Schema.Fireteamrole
    has_many :users, KuikkaDB.Schema.User
  end

  @params [:name, :description]
  @required [:name]

  defp changeset(fireteam, params) when is_map(params) do
    fireteam
    |> cast(params, @params)
    |> validate_required(@required)
    |> unique_constraint(:name)
  end

  @doc """
  Insert new fireteam to database
  """
  def insert(params), do: %__MODULE__{} |> changeset(params) |> Repo.insert

  @doc """
  Update fireteam to database
  """
  def update(schema, params), do: schema |> changeset(params) |> Repo.update

  @doc """
  Get one fireteam from database
  """
  def one(id: id), do: __MODULE__ |> Repo.get(id) |> one_tuple
  def one(opts), do: __MODULE__ |> Repo.get_by(opts) |> one_tuple
  defp one_tuple(nil), do: {:error, "Failed to find fireteam"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all fireteams from database
  """
  def all(), do: Repo.all(__MODULE__)
end
