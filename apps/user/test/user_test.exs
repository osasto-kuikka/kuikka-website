defmodule UserTest do
  use ExUnit.Case
  doctest User

  test "map to struct" do
    user = %{
      username: "test",
      email: "test@test.com",
      imageurl: "http://example.com/test.jpg",
      role: %{
        name: "test",
        permissions: ["test1", "test2"]
      },
      fireteam: %{
        name: "test",
        leader: true,
        role: "test1",
        roles: ["test1", "test2"]
      }
    }
    |> User.to_struct

    assert user.username == "test"
    assert user.email == "test@test.com"
    assert user.imageurl == "http://example.com/test.jpg"

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
