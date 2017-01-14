defmodule KuikkaDB.Controller do
  @moduledoc """
  Controller containing database functions for user
  """
  alias KuikkaDB.{Repo, Schema}
  alias Schema.User, as: UserSchema
  alias Schema.Role, as: RoleSchema

  @doc """
  Get single user from kuikkadb as user struct.

  ## Example
  ```
  {:ok, user} = KuikkaDB.get_user("steamid")
  ```
  """
  @spec get_user(binary) :: {:ok, User.t} | {:error, binary}
  def get_user(steamid) do
    case UserSchema.one(steamid: steamid) do
      {:ok, user} -> user_schema_to_struct(user)
      tuple -> tuple
    end
  end

  @doc """
  Get all users from kuikkadb

  ## Example
  ```
  {:ok, users} = KuikkaDB.get_all_users()
  ```
  """
  @spec get_all_users() :: {:ok, List.t} | {:error, binary}
  def get_all_users() do
    UserSchema.all()
    |> Enum.reduce({:ok, []}, fn user, {:ok, users} ->
      case user_schema_to_struct(user) do
        {:ok, user} -> {:ok, List.insert_at(users, -1, user)}
        tuple -> tuple
      end
    end)
  end

  @doc """
  Adds new user to kuikkadb

  ## Example
  ```
  {:ok, users} = KuikkaDB.new_user("steamid")
  ```
  """
  @spec new_user(binary) :: {:ok, User.t} | {:error, binary}
  def new_user(steamid) do
    case UserSchema.one(steamid: steamid) do
      {:error, _} -> {:ok, insert_user(steamid)}
      {:ok, _} -> {:error, "User with id #{steamid} already exists"} 
    end
  end

  # Insert new user to database. Used in new user when no earlier user was
  # found from database.
  @spec insert_user(binary) :: User.t 
  defp insert_user(steamid) do
    with {:ok, role}   <- RoleSchema.one(name: "user")
    do
      %{
        steamid: steamid,
        role_id: role.id,
      } |> UserSchema.insert |> user_schema_to_struct
    end
  end

  @doc """
  Add new role to kuikkadb

  ## Example
  ```
  :ok = KuikkaDB.new_role("role", "example")
  ```
  """
  @spec new_role(binary, binary) :: :ok | {:error, binary}
  def new_role(name, description) do
    case RoleSchema.one(name: name) do
      {:error, _} ->
        RoleSchema.insert(%{name: name, description: description})
        :ok
      {:ok, _} ->
        {:error, "Role #{name} already exists"}
    end
  end

  @doc """
  Update user role to kuikkadb

  ## Example
  ```
  :ok = KuikkaDB.update_user_role("steamid", "role")
  ```
  """
  @spec update_user_role(binary, binary) :: :ok | {:error, binary}
  def update_user_role(steamid, rolename) do
    with {:ok, user} <- UserSchema.one(steamid: steamid),
         {:ok, role} <- RoleSchema.one(name: rolename),
         user <- Repo.preload(user, [:role])
    do
      case UserSchema.update(user, %{role_id: role.id}) do
        {:ok, _} -> :ok
        tuple -> tuple
      end
    end
  end

  @doc """
  Transform user schema from kuikkadb to user struct

  ## Notice
  This function will preload user role and permissions. If your query does not
  require them you should manually load them before this function

  ## Example
  ```
  schema = KuikkaDB.Schema.User
          |> preload([role: [:permissions]])
          |> where([u] u.steamid == ^steamid)
          |> KuikkaDB.Repo.one!()
  user = KuikkaDB.user_schema_to_struct(schema)
  ```
  """
  @spec user_schema_to_struct(KuikkaDB.Schema.User.t) :: User.t
  def user_schema_to_struct(schema = %UserSchema{}) do
    with {:ok, steam} <- Steam.get_user(schema.steamid)
    do
      schema = Repo.preload(schema, [role: [:permissions]])

      struct!(%User{}, %{
        steamid: "#{schema.steamid}",
        personaname: steam.personaname,
        profileurl: steam.profileurl,
        avatar: steam.avatar,
        avatarmedium: steam.avatarmedium,
        avatarfull: steam.avatarfull,
        createtime: schema.createtime,
        role: %{
          name: schema.role.name,
          permissions: Enum.map(schema.role.permissions, fn p -> p.name end)
        }
      })
    end
  end
end
