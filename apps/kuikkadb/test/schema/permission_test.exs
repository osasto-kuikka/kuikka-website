defmodule KuikkaDBTest.Permission do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Permission, as: PermissionSchema

  setup do
    PermissionSchema.new(%{name: "test permission", description: "Testdescription"})

    {:ok, permission: PermissionSchema.one(name: "test permission")}
  end
  test "new permission", state do
    permission = state[:permission]

    assert permission.name == "test permission"
    assert permission.description == "Testdescription"
  end
  test "delete permission", state do
    permission = state[:permission]

    PermissionSchema.delete(permission)
    permission = PermissionSchema.one(name: "test permission")

    assert permission == nil
  end
  test "update permission", state do
    permission = state[:permission]

    permission = PermissionSchema.update(permission, %{name: "new test", description: "nothing",
                                        new: false})
    permission = PermissionSchema.one(name: "new test")

    assert permission.name == "new test"
    assert permission.description == "nothing"
  end
end
