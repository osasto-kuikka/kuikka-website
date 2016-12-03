defmodule UserTest do
  use ExUnit.Case
  doctest User

  test "map to struct" do
    user = %{
      steamid: 123,
      personaname: "test",
      avatar: "test",
      avatarmedium: "test",
      avatarfull: "test",
      role: %{
        name: "test",
        permissions: ["test1", "test2"]
      },
      fireteam: %{
        name: "test",
        leader: true,
        fireteamrole: "test1",
        fireteamroles: ["test1", "test2"]
      }
    }
    |> User.user_struct

    assert user.steam.steamid == 123

    assert is_map(user.role)
    assert user.role.name == "test"
    assert is_list(user.role.permissions)
    assert Enum.at(user.role.permissions, 0) == "test1"
    assert Enum.at(user.role.permissions, 1) == "test2"

    assert is_map(user.fireteam)
    assert user.fireteam.name == "test"
    assert user.fireteam.leader == true
    assert user.fireteam.role == "test1"
    assert is_list(user.fireteam.roles)
    assert Enum.at(user.fireteam.roles, 0) == "test1"
    assert Enum.at(user.fireteam.roles, 1) == "test2"
  end
end
