defmodule SteamTest do
  use ExUnit.Case

  test "to_struct should transform map to to struct" do
    struct = Steam.to_struct(%{steamid: "test"})
    assert struct.steamid == "test"
    assert is_nil(struct.personaname)
  end

  test "to_struct should return same map" do
    struct = Steam.to_struct(%{steamid: "test"})
    assert struct == Steam.to_struct(struct)
  end
end
