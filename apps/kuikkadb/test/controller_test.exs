defmodule KuikkaDB.ControllerTest do
  @moduledoc """
  Test for kuikkadb controller
  """
  use KuikkaDB.TestCase

  setup do
    {:ok, user} = KuikkaDB.new_user(76561197960435530)
    {:ok, %{user: user}}
  end

  test "new user", %{user: user} do
    assert "#{user.steamid}" == "76561197960435530"
  end

  test "get user", %{user: _} do
    assert {:ok, got_user} = KuikkaDB.get_user(76561197960435530)
    assert got_user.steamid == "76561197960435530"
  end

  test "get all users", %{user: _} do
    assert {:ok, users} = KuikkaDB.get_all_users()
    assert is_list(users)
    assert length(users) > 0
  end

  test "new role", %{user: _} do
    assert {:ok, _} = KuikkaDB.new_role("test", "test")
  end

  test "new fireteam", %{user: _} do
    assert {:ok, _} = KuikkaDB.new_fireteam("test", "test")
  end

  test "new fireteam role", %{user: _} do
    assert {:ok, _} = KuikkaDB.new_fireteam("test", "test")
    assert {:ok, _} = KuikkaDB.new_fireteamrole("test", "test", false, "test")
  end
end
