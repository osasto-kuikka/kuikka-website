defmodule KuikkaDB.Repo.Migrations.SeedPermission do
  @moduledoc """
    Add seed files to kuikkadb.
  """
  use Ecto.Migration
  alias KuikkaDB.Permissions

  def up do
    ins("read_wiki", "Permission to read wiki pages", true)
    ins("read_forum", "Permission to read forums", true)
    ins("read_event", "Permission to read events", true)
    ins("create_wiki_page", "Permission to create wigi pages", false)
    ins("modify_wiki", "Permission to modify wiki pages", false)
    ins("create_forum_post", "Permission to create new forum posts", false)
    ins("create_event", "Permission to create new events", false)
    ins("create_topic_comment", "Permission to comment forum topics", false)
    ins("create_event_comment", "Permission to comment events", false)
  end

  def down do
    del(name: "read_wiki")
    del(name: "create_wiki_page")
    del(name: "modify_wiki")
    del(name: "read_forum")
    del(name: "read_event")
    del(name: "create_wiki")
    del(name: "create_forum_post")
    del(name: "create_event")
    del(name: "create_topic_comment")
    del(name: "create_event_comment")
  end

  defp ins(name, desc, no_login) do
    Permissions.insert(name: name, description: desc, no_login: no_login)
  end
  defp del(name) do
    Permissions.delete(name: name)
  end
end
