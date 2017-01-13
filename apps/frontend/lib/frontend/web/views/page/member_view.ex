defmodule Frontend.Page.MemberView do
  use Frontend.Web, :view

  @steam_profile_base_url "http://steamcommunity.com/id/"

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
end
