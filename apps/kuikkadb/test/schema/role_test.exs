defmodule KuikkaDBTest.Role do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Role, as: RoleSchema

  setup do
    RoleSchema.new(%{name: "testRole", description: "Testdescription"})

    {:ok, role: RoleSchema.one(name: "testRole")}
  end
  test "new role", %{role: role} do
    assert role.name == "testRole"
    assert role.description == "Testdescription"
  end
  test "delete role", %{role: role} do
    RoleSchema.delete(role)
    role = RoleSchema.one(name: "testRole")

    assert role == nil
  end
  test "update role", %{role: role} do
    role = RoleSchema.update(role, %{name: "new test", description: "nothing"})
    role = RoleSchema.one(name: "new test")

    assert role.name == "new test"
    assert role.description == "nothing"
  end
end
