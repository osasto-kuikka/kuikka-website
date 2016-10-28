defmodule KuikkaDBTest.User do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema


  setup do
    UserSchema.new(%{username: "test", email: "test@test.com",
                          password: "test"})
    {:ok, user: UserSchema.one(username: "test")}
  end
  test "new user", state do
    user = state[:user]
    assert user.username == "test"
    assert user.email == "test@test.com"
    assert user.imageurl == "http://test.osastokuikka.com/images/logo.svg"
  end
  test "delete user", state do
    user = state[:user]
    UserSchema.delete(user)

    user = UserSchema.one(username: "test")

    assert user == nil
  end
  test "update user", state do
    user = state[:user]
    user = UserSchema.update(user, %{username: "jokuAIVANmuu", email: "newmail@mail.com"})
    user = UserSchema.one(username: "jokuAIVANmuu")

    assert user.username == "jokuAIVANmuu"
    assert user.email == "newmail@mail.com"
  end
end
