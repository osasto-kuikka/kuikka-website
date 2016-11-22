defmodule KuikkaDB.Schema.User do
  @moduledoc """
  A module providing tables for user:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for users.
  Please see user table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}
  alias Schema.Role, as: RoleSchema
  alias Schema.Fireteam, as: FireteamSchema
  alias Schema.Fireteamrole, as: FireteamRoleSchema

  @timestamps_opts [usec: true]
  schema "user" do
    field :steamid, :decimal
    belongs_to :role, Schema.Role
    belongs_to :fireteam, Schema.Fireteam
    belongs_to :fireteamrole, Schema.Fireteamrole
    field :new, :boolean, virtual: true
    timestamps()
  end

  @doc """
  Add new user
  """
  def new(steamid) do
    params = %{steamid: steamid, new: true}
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Update user
  """
  def update(schema = %__MODULE__{}, params) when is_map(params) do
    params = Map.put(params, :new, false)
    schema |> changeset(params) |> Repo.update
  end

  @doc """
  Get one user struct from database
  """
  def one(id: id), do: Repo.get(__MODULE__, id) |> to_struct
  def one(opts), do: Repo.get_by(__MODULE__, opts) |> to_struct

  @doc """
  Get all users from database
  """
  def all(), do: __MODULE__ |> Repo.all |> Enum.map(&to_struct/1)

  @doc """
  Transform user schema to user struct
  """
  def to_struct(schema = %__MODULE__{}) do
    steam = Steam.get_user(schema.steamid)
    schema = Repo.preload(schema, [:fireteamrole,
                                   role: [:permissions],
                                   fireteam: [:fireteamroles]])
    %{
      steam: steam,
      role: %{
        name: schema.role.name,
        permissions: Enum.map(schema.role.permissions, fn p -> p.name end)
      },
      fireteam: %{
        name: schema.fireteam.name,
        role: schema.fireteamrole.name,
        roles: Enum.map(schema.fireteam.fireteamroles, fn r -> r.name end)
      }
    }
    |> User.to_struct
  end
  def to_struct(_) do
    nil
  end

  def changeset(user, params) when is_map(params) do
      user
      |> cast(params, [:steamid, :role_id, :fireteam_id,
                       :fireteamrole_id, :new])
      |> validate_required([:steamid])
      |> changeset_new
  end
  defp changeset_new(changeset) do
    if get_change(changeset, :new) do
      with role <- RoleSchema.one(name: "user"),
           fireteam <- FireteamSchema.one(name: "none"),
           fireteamrole <- FireteamRoleSchema.one(name: "none",
                                                  fireteam_id: fireteam.id)
      do
        changeset
        |> put_assoc(:role, role)
        |> put_assoc(:fireteam, fireteam)
        |> put_assoc(:fireteamrole, fireteamrole)
      end
    else
      changeset
    end
  end
end
