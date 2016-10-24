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
  import Comeonin.Bcrypt

  alias KuikkaDB.{Repo, Schema}
  alias Schema.Role, as: RoleSchema
  alias Schema.Fireteam, as: FireteamSchema
  alias Schema.Fireteamrole, as: FireteamRoleSchema

  @timestamps_opts [usec: true]
  schema "user" do
    field :username, :string
    field :password, :string
    field :email, :string
    field :imageurl, :string
    field :signature, :string
    belongs_to :role, Schema.Role
    belongs_to :fireteam, Schema.Fireteam
    belongs_to :fireteamrole, Schema.Fireteamrole
    field :new, :boolean, virtual: true
    field :delete, :boolean, virtual: true
    timestamps()
  end

  @doc """
  Add new user
  """
  def new(params) do
    params = Map.put(params, :new, true)
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Update user
  """
  def update(schema = %__MODULE__{}, params) do
    schema |> changeset(params) |> Repo.update
  end

  @doc """
  Delete user
  """
  #def delete(struct) do
   # struct |> changeset(%{delete: true}) |> Repo.update
  #end
  def delete(schema = %__MODULE__{}) do
    schema |> change(%{delete: true}) |> Repo.update
  end

  @doc """
  Get one user sturct with id, email or username
  """
  def sturct(id: id),
    do: __MODULE__ |> Repo.get(id) |> to_struct
  def struct(opts),
    do: __MODULE__ |> Repo.get_by(opts) |> to_struct

  @doc """
  Get one user schema with id, email or username
  """
  def one(id: id),
    do: __MODULE__ |> Repo.get(id)
  def one(opts),
    do: __MODULE__ |> Repo.get_by(opts)

  @doc """
  Get all users
  """
  def all(),
    do: __MODULE__ |> Repo.all |> Enum.map(&to_struct/1)

  @doc """
  Transform user schema to struct
  """
  def to_struct(schema = %__MODULE__{}) do
    schema = Repo.preload(schema, [:fireteamrole,
                                   role: [:permissions],
                                   fireteam: [:fireteamroles]])
    %{
      username: schema.username,
      email: schema.email,
      imageurl: schema.imageurl,
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

  def changeset(user, params) when is_map(params) do
      user
      |> cast(params, [:username, :password, :email, :imageurl,
                       :signature, :role_id, :fireteam_id, :fireteamrole_id,
                       :new, :delete])
      |> validate_required([:username, :email, :password])
      |> validate_format(:email, ~r/@/)
      |> unique_constraint(:username)
      |> unique_constraint(:email)
      |> changeset_password
      |> changeset_new
      |> changeset_delete
  end
  defp changeset_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      "" -> add_error(changeset, :password, "empty")
      pass -> change(changeset, %{password: hashpwsalt(pass)})
    end
  end
  defp changeset_new(changeset) do
    if get_change(changeset, :new) do
      with role <- RoleSchema.one(name: "user"),
           fireteam <- FireteamSchema.one(name: "none")
      do
        fireteamrole = FireteamRoleSchema.one(name: "none",
                                              fireteam_id: fireteam.id)
        changeset
        |> change(%{imageurl: "http://test.osastokuikka.com/images/logo.svg"})
        |> put_assoc(:role, role)
        |> put_assoc(:fireteam, fireteam)
        |> put_assoc(:fireteamrole, fireteamrole)
      end
    else
      changeset
    end
  end
  defp changeset_delete(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
