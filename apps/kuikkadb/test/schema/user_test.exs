defmodule KuikkaDBTest do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema


  setup do
    UserSchema.new(%{username: "test", email: "test@test.com",
                          password: "test"})
    {:ok, user: UserSchema.one(username: "test")}
   # {:ok, user_struct: UserSchema.struct(username: "test")}
  end
  test "new user", state do
    user = UserSchema.struct(username: "test")
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
    updated_user_struct = UserSchema.struct(username: "jokuAIVANmuu")

    assert updated_user_struct.username == "jokuAIVANmuu"
    assert updated_user_struct.email == "newmail@mail.com"
  end
end
