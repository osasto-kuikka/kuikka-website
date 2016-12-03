defmodule KuikkaDBTest.User do
  @moduledoc """
  Tests for user data adding, updating,
  correct password, correct email
  and removing on kuikkadb.
  """
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema

  setup do
    UserSchema.new(123)
    {:ok, user: UserSchema.one(steamid: 123)}
  end

  test "new user", %{user: user} do
    assert user.steam.steamid == 123
  end

  test "update user", %{user: user} do
    UserSchema.update(user, %{steamid: 321})
    user2 = UserSchema.one(steamid: 321)
    assert user.id == user2.id
    assert user2.username == 321
  end
end
