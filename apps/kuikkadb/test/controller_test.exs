defmodule KuikkaDB.ControllerTest do
  @moduledoc """
  Test for kuikkadb controller
  """
  use KuikkaDB.TestCase

  setup do
    # Steam ID with tests is the steamid that valve uses as an
    # example on how to query steam user from steam api
    user = KuikkaDB.new_user(76_561_197_960_435_530)
    {:ok, %{user: user}}
  end

  test "new user", %{user: user} do
    assert "#{user.profile.steam_id64}" == "76561197960435530"
  end

  test "get user", %{user: _} do
    # Allow failure with missing steam api key for CI
    # This need to be fixed when proper fix is found for CI testing
    user = case KuikkaDB.get_user(76_561_197_960_435_530) do
      user = %User{} -> {:ok, user}
      {:error, "Missing STEAM_API_KEY"} -> {:ok, nil}
      tuple -> tuple
    end
    assert {:ok, _} = user
  end

  test "get all users", %{user: _} do
    # Allow failure with missing steam api key for CI
    # This need to be fixed when proper fix is found for CI testing
    users = KuikkaDB.get_all_users()
    assert is_list(users)
  end

  test "new role", %{user: _} do
    assert :ok = KuikkaDB.new_role("test", "test")
  end
end
