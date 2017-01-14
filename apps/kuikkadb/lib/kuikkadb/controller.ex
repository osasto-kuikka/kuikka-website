defmodule KuikkaDB.Controller do
  @moduledoc """
  Controller containing database functions for user
  """
  alias KuikkaDB.{Repo, Schema}
  alias Schema.User, as: UserSchema
  alias Schema.Role, as: RoleSchema

  @doc """
  Get single user from database as user struct.

  This function will automatically request data from steam api to
  build proper user struct for frontend usage.
  """
  def get_user(steamid) do
    case UserSchema.one(steamid: steamid) do
      {:ok, user} -> user_schema_to_struct(user)
      tuple -> tuple
    end
  end

  @doc """
  Get all user from database.

  This function returns user structs so every user info have been requested
  steam api.
  """
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
  Adds new user to database. Should be automatically used when user first
  time logins from steam.
  """
  def new_user(steamid) do
    case UserSchema.one(steamid: steamid) do
      {:error, _} -> insert_user(steamid)
      {:ok, user} -> {:ok, user}
    end
  end
  # Insert new user to database. Used in new user when no earlier user was
  # found from database.
  defp insert_user(steamid) do
    with {:ok, role}   <- RoleSchema.one(name: "user")
    do
      %{
        steamid: steamid,
        role_id: role.id,
      } |> UserSchema.insert
    end
  end

  @doc """
  Insert new role to kuikkadb. Returns error tuple if role already exists
  otherwise it will return ok tuple when new role was inserted to kuikkadb
  """
  def new_role(name, description) do
    case RoleSchema.one(name: name) do
      {:error, _} ->
        RoleSchema.insert(%{name: name, description: description})
      {:ok, _} ->
        {:error, "Role #{name} already exists"}
    end
  end

  @doc """
  Update user role to database. This is will return atom with
  `:ok` when user was properly updated and `{:error, msg}`
  when there is issue with updating.
  """
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

  # Transform user schema to user struct
  # This function will load all information from database and
  # request user data with steamid from steam api to build user struct
  defp user_schema_to_struct(schema = %UserSchema{}) do
    with {:ok, role} <- RoleSchema.one(id: schema.role_id),
         {:ok, steam} <- Steam.get_user(schema.steamid)
    do
      role = Repo.preload(role, [:permissions])

      %{
        steamid: "#{schema.steamid}",
        personaname: steam.personaname,
        profileurl: steam.profileurl,
        avatar: steam.avatar,
        avatarmedium: steam.avatarmedium,
        avatarfull: steam.avatarfull,
        createtime: schema.createtime,
        role: %{
          name: role.name,
          permissions: Enum.map(role.permissions, fn p -> p.name end)
        }
      } |> User.user_struct
    end
  end
end
