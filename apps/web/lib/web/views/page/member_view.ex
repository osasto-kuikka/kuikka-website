defmodule Web.Page.MemberView do
  use Web, :view

  @steam_profile_base_url "http://steamcommunity.com/id/"

  alias KuikkaDB.UserSchema

  @doc """
  Get user steam url
  """
  @spec get_steam_url(Steamex.Profile.t) :: binary
  def get_steam_url(steam_profile) do
    if not is_nil(steam_profile.custom_url) do
      @steam_profile_base_url <> steam_profile.custom_url
    else
      @steam_profile_base_url <> "#{steam_profile.steam_id64}"
    end
  end

  @doc """
  Get all members
  """
  @spec get_members() :: [UserSchema.t]
  def get_members do
    UserSchema
    |> preload([:role])
    |> Repo.all()
    |> Enum.map(&User.add_profile(&1))
  end

  @doc """
  Get single member
  """
  @spec get_member(Plug.Conn.t) :: UserSchema.t
  def get_member(%{params: %{"id" => id}}) do
    UserSchema
    |> preload([:role])
    |> where([u], u.steamid == ^id)
    |> Repo.one()
    |> case do
      nil -> nil
      user -> User.add_profile(user)
    end
  end
end
