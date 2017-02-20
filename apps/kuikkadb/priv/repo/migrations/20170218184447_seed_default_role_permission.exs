defmodule KuikkaDB.Repo.Migrations.SeedDefaultRolePermission do
  use Ecto.Migration

  alias KuikkaDB.Roles
  alias KuikkaDB.Permissions
  alias KuikkaDB.RolePermissions, as: RP

  def up do
#    {:ok, admin_permissions} = Permissions.get_all()
    insert_role_permissions("admin", Permissions.get_all())
  #  insert_role_permissions("user")
  end

  def down do
    {:ok, [admin]} = Roles.get(name: "admin")
    RP.delete(role_id: admin.id)
  end

#  @spec insert_role_permissions(binary, binary | list) ::
#                                        {:ok, Ecto.Schema.t} | {:error, binary}
  defp insert_role_permissions(role_name, permissions = [perm | _])
                                                      when is_binary(perm) do
    {:ok, [role]} = Roles.get(name: role_name)
    for p <- permissions do
      {:ok, [permission]} = Permissions.get(name: p.name)
      {:ok, _} = RP.insert(role_id: role.id, permission_id: permission.id)
    end
  end

#  @spec insert_role_permissions(binary, map) ::
#                                        {:ok, Ecto.Schema.t} | {:error, map}
  defp insert_role_permissions(role_name, permissions = [perm | _])
                                                when is_map(perm) do
    {:ok, [role]} = Roles.get(name: role_name)
    for p <- permissions do
  #    {:ok, [permission]} = Permissions.get(name: p.name)
      {:ok, _} = RP.insert(role_id: role.id, permission_id: p.id)
    end
  end
end
