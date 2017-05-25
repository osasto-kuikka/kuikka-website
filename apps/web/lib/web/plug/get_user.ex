defmodule Web.Plug.GetUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  import Ecto.Query
  import Plug.Conn

  alias KuikkaDB.{Repo, UserSchema, RoleSchema}
  alias Ecto.Changeset

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    case get_session(conn, :steamid64) do
      nil -> assign(conn, :current_user, nil)
      user -> assign(conn, :current_user, get_user(user))
    end
  end

  @spec get_user(integer) :: term
  defp get_user(steamid) do
    UserSchema
    |> where([u], u.steamid == ^steamid)
    |> preload([role: [:permissions]])
    |> Repo.one()
    |> case do
      nil -> create_user(steamid)
      user -> user
    end
    |> User.add_profile()
  end

  @spec create_user(integer) :: Users.t
  defp create_user(steamid) do
    default_role = Repo.get_by(RoleSchema, name: "user")
    %UserSchema{}
    |> UserSchema.changeset(%{steamid: steamid})
    |> Changeset.put_assoc(:role, default_role)
    |> Repo.insert!()
  end
end
