defmodule KuikkaDB.Schema.User do
  @moduledoc """
  Database schema for user table
  """
  use Ecto.Schema
  use Timex.Ecto.Timestamps
  import Ecto.Changeset

  alias KuikkaDB.Repo

  schema "user" do
    field :steamid, :decimal
    field :createtime, Timex.Ecto.DateTime
    field :modifytime, Timex.Ecto.DateTime
    belongs_to :role, KuikkaDB.Schema.Role
  end

  @params [:steamid, :role_id, :createtime, :modifytime]
  @required [:steamid, :role_id]

  @doc """
  Validate changes to user
  """
  def changeset(user, params) when is_map(params) do
    user
    |> cast(params, @params)
    |> validate_required(@required)
    |> add_timestamps
  end
  defp add_timestamps(changeset) do
    if is_nil(get_field(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now)
    else
      put_change(changeset, :modifytime, Timex.now)
    end
  end

  @doc """
  Insert new user to database
  """
  def insert(params), do: %__MODULE__{} |> changeset(params) |> Repo.insert

  @doc """
  Update user to database
  """
  def update(schema, params), do: schema |> changeset(params) |> Repo.update

  @doc """
  Get one user struct from database
  """
  def one(id: id), do: __MODULE__ |> Repo.get(id) |> one_tuple
  def one(opts), do: __MODULE__ |> Repo.get_by(opts) |> one_tuple
  defp one_tuple(nil), do: {:error, "Failed to find user"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all users from database
  """
  def all(), do: Repo.all(__MODULE__)
end
