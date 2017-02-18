defmodule KuikkaDB.Repo.Migrations.SeedDefaultRolePermission do
  use Ecto.Migration

  alias KuikkaDB.Roles
  alias KuikkaDB.Permissions
  alias KuikkaDB.RolePermissions, as: RP

  def up do
    insert_role_permissions("admin")
  #  insert_role_permissions("user")
  end

  def down do
    RP.delete(id: 1)
  end

  @spec insert_role_permissions(binary) ::
                                        {:ok, Ecto.Schema.t} | {:error, binary}
  defp insert_role_permissions(name) do
    {:ok, [admin]} = Roles.get(name: "admin")
    {:ok, all_permissions} = Permissions.get_all()
    for p <- all_permissions do
      RP.insert(role_id: admin.id, permission_id: p.id)
    end
  end
end
