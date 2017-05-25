defmodule KuikkaDB.Repo.Migrations.SeedDefaultRolePermission do
  use Ecto.Migration
  import Ecto.Query

  alias KuikkaDB.{Repo, RoleSchema, PermissionSchema}
  alias Ecto.Changeset

  def up do
    permissions = Repo.all(PermissionSchema)
    reads = Enum.filter(permissions, &String.starts_with?(&1.name, "read_"))

    RoleSchema
    |> where([r], r.name == "admin")
    |> preload(:permissions)
    |> Repo.one!()
    |> RoleSchema.changeset(%{})
    |> Changeset.put_assoc(:permissions, permissions)
    |> Repo.update!()

    RoleSchema
    |> where([r], r.name == "user")
    |> preload(:permissions)
    |> Repo.one!()
    |> RoleSchema.changeset(%{})
    |> Changeset.put_assoc(:permissions, reads)
    |> Repo.update!()
  end

  def down do
  end
end
