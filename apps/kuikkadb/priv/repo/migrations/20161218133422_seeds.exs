defmodule KuikkaDB.Repo.Migrations.Seeds do
  @moduledoc """
  Add seed files to kuikkadb.

  TODO:
  Should be included to table creation migrations on next migration cleanup
  """
  use Ecto.Migration
  alias KuikkaDB.Roles

  def up do
    Roles.insert(name: "user", description: "Basic User")
    Roles.insert(name: "admin", description: "Admin User")
  end

  def down do
    Roles.delete(name: "user")
    Roles.delete(name: "admin")
  end
end
