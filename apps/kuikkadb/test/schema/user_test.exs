defmodule KuikkaDBTest do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema

  test "new user" do
    UserSchema.new(%{username: "test", email: "test@test.com",
                      password: "test"})
    user = UserSchema.one(username: "test")

    assert user.username == "test"
    assert user.email == "test@test.com"
    assert user.imageurl == "http://test.osastokuikka.com/images/logo.svg"
  end
end
