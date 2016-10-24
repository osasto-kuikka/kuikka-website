defmodule KuikkaDBTest do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema

  test "new user" do
    UserSchema.new(%{username: "test", email: "test@test.com",
                      password: "test"})
    user = UserSchema.struct(username: "test")

    assert user.username == "test"
    assert user.email == "test@test.com"
    assert user.imageurl == "http://test.osastokuikka.com/images/logo.svg"
  end
  test "delete user" do
    UserSchema.new(%{username: "delete_this", email: "delete@delete.com",
                      password: "test"})
    delete_cantidate = UserSchema.one(username: "delete_this")

    UserSchema.delete(delete_cantidate)

    delete_cantidate = UserSchema.one(username: "delete_this")

    assert delete_cantidate == nil
  end
end
