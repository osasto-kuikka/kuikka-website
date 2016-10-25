defmodule KuikkaDBTest.Role do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Role, as: RoleSchema

  setup do
    RoleSchema.new(%{name: "testRole", description: "Testdescription"})

    {:ok, role: RoleSchema.one(name: "testRole")}
  end
  test "new role", state do
    role = state[:role]

    assert role.name == "testRole"
    assert role.description == "Testdescription"
  end
  test "delete role", state do
    role = state[:role]

    RoleSchema.delete(role)
    role = RoleSchema.one(name: "testRole")

    assert role == nil
  end

  test "update role", state do
    role = state[:role]

    role = RoleSchema.update(role, %{name: "new test", description: "nothing",
                             new: false})
    role = RoleSchema.one(name: "new test")

    assert role.name == "new test"
    assert role.description == "nothing"
  end
end
