defmodule KuikkaDB.Schema.Role do
  @moduledoc """
  This Schema and changeset is for roles.
  Please see role table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Repo

  schema "role" do
    field :name, :string
    field :description, :string
    many_to_many :permissions, KuikkaDB.Schema.Permission,
                               join_through: "role_permission"
    has_many :users, KuikkaDB.Schema.User
  end

  @params [:name, :description]
  @required [:name]

  @doc """
  Validate changes to role
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
  defp one_tuple(nil), do: {:error, "Failed to find role"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all roles from database
  """
  def all(), do: Repo.all(__MODULE__)
end
