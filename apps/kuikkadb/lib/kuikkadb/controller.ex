defmodule KuikkaDB.Controller do
  @moduledoc """
  Controller containing database functions for user
  """
  import Ecto.Query
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
  @spec get_user(binary) :: User.t | nil
  def get_user(steamid) do
    UserSchema
    |> preload(role: :permissions)
    |> where([u], u.steamid == ^steamid)
    |> Repo.one()
    |> case do
      nil -> nil
      user -> user_schema_to_struct(user)
    end
  end

  @doc """
  Get all users from kuikkadb

  ## Example
  ```
  {:ok, users} = KuikkaDB.get_all_users()
  ```
  """
  @spec get_all_users() :: List.t
  def get_all_users() do
    UserSchema
    |> preload(role: :permissions)
    |> Repo.all()
    |> Enum.map(&user_schema_to_struct(&1))
  end

  @doc """
  Adds new user to kuikkadb

  ## Example
  ```
  {:ok, users} = KuikkaDB.new_user("steamid")
  ```
  """
  @spec new_user(binary) :: User.t
  def new_user(steamid) do
    case get_user(steamid) do
      nil -> insert_user(steamid)
      user -> user
    end
  end

  # Insert new user to database. Used in new user when no earlier user was
  # found from database.
  @spec insert_user(binary) :: User.t
  defp insert_user(steamid) do
    role = RoleSchema
          |> where([r], r.name == "user")
          |> Repo.one!()

    %UserSchema{}
    |> UserSchema.changeset(%{steamid: steamid, role_id: role.id})
    |> Repo.insert!()
    |> Repo.preload(role: :permissions)
    |> user_schema_to_struct()
  end

  @doc """
  Add new role to kuikkadb

  ## Example
  ```
  :ok = KuikkaDB.new_role("role", "example")
  ```
  """
  @spec new_role(binary, binary) :: :ok
  def new_role(name, description) do
    RoleSchema
    |> where([r], r.name == ^name)
    |> Repo.one()
    |> case do
      nil ->
        %RoleSchema{}
        |> RoleSchema.changeset(%{name: name, description: description})
        |> Repo.insert()
      _ -> nil
    end
    :ok
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
    user = UserSchema
           |> preload(:role)
           |> where([u], u.steamid == ^steamid)
           |> Repo.one()

    role = RoleSchema
           |> where([r], r.name == ^rolename)
           |> Repo.one()

    with {:ok, user} <- user,
         {:ok, role} <- role
    do
      user
      |> UserSchema.changeset(%{role_id: role.id})
      |> Repo.update()

      :ok
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
    role = %{
      name: schema.role.name,
      permissions: Enum.map(schema.role.permissions, fn p -> p.name end)
    }
    times = %{
      createtime: schema.createtime,
      modifytime: schema.modifytime
    }
    User.get_user("#{schema.steamid}", role, times)
  end
end
