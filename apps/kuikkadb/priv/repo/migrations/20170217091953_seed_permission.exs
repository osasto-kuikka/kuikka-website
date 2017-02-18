defmodule KuikkaDB.Repo.Migrations.SeedPermission do

  use Ecto.Migration
  alias KuikkaDB.Permissions

  def up do
    Permissions.insert(name: "read_wiki", description: "Permission to read wiki pages")
    Permissions.insert(name: "read_forum", description: "Permission to read forums")
    Permissions.insert(name: "read_event", description: "Permission to read events")
    Permissions.insert(name: "create_wiki", description: "Permission to create wiki pages")
    Permissions.insert(name: "create_forum_post", description: "Permission to create new forum posts")
    Permissions.insert(name: "create_event", description: "Permission to create new events")
  end

  def down do

  end
end
