defmodule User do
  @moduledoc """
  Defines user struct for usage to other components
  """
  alias User.Role
  alias Steamex.Profile

  defmodule Role do
    @moduledoc false
    defstruct name: nil, permissions: []

    @type t :: %__MODULE__{
      name: binary,
      permissions: List.t
    }
  end

  defstruct profile: nil, role: nil, createtime: nil, modifytime: nil

  @type t :: %__MODULE__{
    profile: Steamex.Profile.t,
    role: User.Role.t,
    createtime: Datetime.t,
    modifytime: Datetime.t | nil
  }

  @doc """
  Get user profile.

  ## Example
  ```
  user = User.get_user("steamid", %{name: "role", permissions: []})
  ```
  """
  @spec get_user(binary | integer, %{name: binary, permissions: List.t},
                  %{createtime: Datetime.t, modifytime: Datetime.t}) :: User.t
  def get_user(steamid, role, times) when is_binary(steamid) do
    case Integer.parse(steamid) do
      {steamid, ""} -> get_user(steamid, role, times)
      tuple -> tuple
    end
  end
  def get_user(steamid, role, times) when is_integer(steamid) do
    struct!(%__MODULE__{}, %{
      profile: Profile.fetch(steamid),
      role: struct!(%Role{}, role),
      createtime: times.createtime,
      modifytime: times.modifytime
    })
  end
end
