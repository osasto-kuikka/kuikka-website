defmodule KuikkaDB.Schema.Permission do
  @moduledoc """
  A module providing tables for permission:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for permissions.
  Please see permission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}

  schema "permission" do
    field :name, :string
    field :description, :string
    many_to_many :roles, Schema.Role, join_through: "role_permission"
  end

  @params [:name, :description]
  @required [:name]
  @preload [:roles]

  @doc """
  Validate changes to role table
  """
  def changeset(role, params) do
    role
    |> cast(params, @params)
    |> validate_required(@required)
    |> unique_constraint(:name)
  end

  @doc """
  Insert new role to database
  """
  def insert(params), do: %__MODULE__{} |> changeset(params) |> Repo.insert

  @doc """
  Update role to database
  """
  def update(schema, params), do: schema |> changeset(params) |> Repo.update

  @doc """
  Get one role from database
  """
  def one(id: id), do: __MODULE__ |> Repo.get(id) |> one_tuple
  def one(opts), do: __MODULE__ |> Repo.get_by(opts) |> one_tuple
  defp one_tuple(nil), do: {:error, "Failed to find permission"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all roles from database
  """
  def all(), do: Repo.all(__MODULE__)
end
