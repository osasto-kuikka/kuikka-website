defmodule KuikkaDB.Controller do
  @moduledoc """
  Controller containing database functions for user
  """
  alias KuikkaDB.{Repo, Schema}
  alias Schema.User, as: UserSchema
  alias Schema.Role, as: RoleSchema
  alias Schema.Fireteam, as: FireteamSchema
  alias Schema.Fireteamrole, as: FireteamroleSchema

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
    with {:ok, role}   <- RoleSchema.one(name: "user"),
         {:ok, ft}     <- FireteamSchema.one(name: "none"),
         {:ok, ftrole} <- FireteamroleSchema.one(name: "none",
                                                 fireteam_id: ft.id)
    do
      %{
        steamid: steamid,
        role_id: role.id,
        fireteam_id: ft.id,
        fireteamrole_id: ftrole.id
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
  Insert new fireteam to kuikkadb. Returns error tuple if fireteam already
  exists otherwise it will return ok tuple when new fireteam was inserted
  to kuikkadb
  """
  def new_fireteam(name, description) do
    case FireteamSchema.one(name: name) do
      {:error, _} ->
        FireteamSchema.insert(%{name: name, description: description})
      {:ok, _} ->
        {:error, "Fireteam #{name} already exists"}
    end
  end

  @doc """
  Insert new fireteam to kuikkadb. Returns error tuple if fireteam already
  exists otherwise it will return ok tuple when new fireteam was inserted
  to kuikkadb
  """
  def new_fireteamrole(name, description, is_leader, fireteam) do
    with {:ok, fireteam} <- FireteamSchema.one(name: fireteam)
    do
      case FireteamroleSchema.one(name: name) do
        {:error, _} ->
          FireteamroleSchema.insert(%{name: name,
                                      description: description,
                                      is_leader: is_leader,
                                      fireteam_id: fireteam.id})
        {:ok, _} ->
          {:error, "Fireteam role #{name} already exists"}
      end
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


  @doc """
  Update user fireteam. This is will return atom with
  `:ok` when user was properly updated and `{:error, msg}`
  when there is issue with updating.
  """
  def update_user_ftrole(steamid, fireteamname, fireteamrolename) do
    with {:ok, user}   <- UserSchema.one([steamid: steamid]),
         {:ok, ft}     <- FireteamSchema.one(name: fireteamname),
         {:ok, ftrole} <- FireteamroleSchema.one(name: fireteamrolename),
         user <- Repo.preload(user, [:fireteam, :fireteamrole])
    do
      user
      |> UserSchema.update(%{fireteam_id: ft.id fireteamrole_id: ftrole.id})
      |> case do
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
         {:ok, ft} <- FireteamSchema.one(id: schema.fireteam_id),
         {:ok, ftrole} <- FireteamroleSchema.one(id: schema.fireteamrole_id),
         {:ok, steam} <- Steam.get_user(schema.steamid)
    do
      role = Repo.preload(role, [:permissions])
      ft = Repo.preload(ft, [:fireteamroles])

      %{
        steamid: "#{schema.steamid}",
        personaname: steam.personaname,
        profileurl: steam.profileurl,
        avatar: steam.avatar,
        avatarmedium: steam.avatarmedium,
        avatarfull: steam.avatarfull,
        role: %{
          name: role.name,
          permissions: Enum.map(role.permissions, fn p -> p.name end)
        },
        fireteam: %{
          name: ft.name,
          leader: ftrole.is_leader,
          fireteamrole: ftrole.name,
          fireteamroles: Enum.map(ft.fireteamroles, fn f -> f.name end)
        }
      } |> User.user_struct
    end
  end
end
