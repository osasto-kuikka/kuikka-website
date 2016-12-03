defmodule KuikkaDB.ControllerTest do
  @moduledoc """
  Test for kuikkadb controller
  """
  use KuikkaDB.TestCase

  test "new user" do
    assert {:ok, user} = KuikkaDB.new_user(123)
    assert "#{user.steamid}" == "123"
  end
end
