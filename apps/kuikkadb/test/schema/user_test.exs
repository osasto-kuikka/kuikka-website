defmodule KuikkaDBTest.User do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.User, as: UserSchema


  setup do
    UserSchema.new(%{username: "test", email: "test@test.com",
                          password: "test"})
    {:ok, user: UserSchema.one(username: "test")}
  end
  test "new user", %{user: user} do
    assert user.username == "test"
    assert user.email == "test@test.com"
    assert user.imageurl == "http://test.osastokuikka.com/images/logo.svg"
  end
  test "delete user", %{user: user} do
    UserSchema.delete(user)

    user = UserSchema.one(username: "test")

    assert user == nil
  end
  test "update user", %{user: user} do
    user = UserSchema.update(user, %{username: "jokuAIVANmuu", email: "newmail@mail.com"})
    user = UserSchema.one(username: "jokuAIVANmuu")

    assert user.username == "jokuAIVANmuu"
    assert user.email == "newmail@mail.com"
  end
  test "password is not in plaintext", %{user: user} do
    assert user.password != "test"
  end
  test "invalid email type" do
    UserSchema.new(%{username: "super", email: "super.useratluukku.com",
                            password: "moi"})
    user = UserSchema.one(username: "super")
    assert user == nil
  end
  test "empty password" do
    UserSchema.new(%{username: "super", email: "email@email.email"})
    user = UserSchema.one(username: "super")

    assert user == nil
  end
end
