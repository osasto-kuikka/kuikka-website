defmodule KuikkaDBTest.Permission do
  use KuikkaDB.TestCase

  alias KuikkaDB.Schema.Permission, as: PermissionSchema

  setup do
    PermissionSchema.new(%{name: "test permission", description: "Testdescription"})

    {:ok, permission: PermissionSchema.one(name: "test permission")}
  end
  test "new permission", %{permission: permission} do
    assert permission.name == "test permission"
    assert permission.description == "Testdescription"
  end
  test "delete permission", %{permission: permission} do
    PermissionSchema.delete(permission)
    permission = PermissionSchema.one(name: "test permission")

    assert permission == nil
  end
  test "update permission", %{permission: permission} do
    permission = PermissionSchema.update(permission, %{name: "new test", description: "nothing"})
    permission = PermissionSchema.one(name: "new test")

    assert permission.name == "new test"
    assert permission.description == "nothing"
  end
end
