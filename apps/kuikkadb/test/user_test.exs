defmodule KuikkaDB.User.Test do
  @moduledoc """
  Test for kuikkadb controller
  """
  use KuikkaDB.TestCase

  alias KuikkaDB.Users
  alias KuikkaDB.Roles

  test "basic queries user" do
    assert {:ok, [role]} = Roles.get(name: "admin")
    assert {:ok, _} = Users.insert(steamid: 123, role_id: role.id,
                                      createtime: Timex.now())
    assert {:ok, _} = Users.get(steamid: 123)

    assert {:ok, [user]} = Users.get_with_role(123)
    assert Decimal.to_integer(user.steamid) == 123
  end

  test "get user with role" do
    assert {:ok, [role]} = Roles.get(name: "admin")
    assert {:ok, _} = Users.insert(steamid: 123, role_id: role.id,
                                      createtime: Timex.now())
    assert {:ok, _} = Users.get_with_role(123)

    assert {:ok, [user]} = Users.get_with_role(123)
    assert Decimal.to_integer(user.steamid) == 123
    assert user.role == "admin"
  end
end
