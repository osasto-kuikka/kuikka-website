defmodule KuikkaDB.Repo.Migrations.AddPermissions do
  @moduledoc """
    Add seed files to kuikkadb.
  """
  use Ecto.Migration
  alias KuikkaDB.{Repo, PermissionSchema}

  def up do
    ins("read_wiki", "Permission to read wiki pages", false)
    ins("read_forum", "Permission to read forums", false)
    ins("read_event", "Permission to read events", false)
    ins("create_wiki_page", "Permission to create wigi pages", true)
    ins("modify_wiki", "Permission to modify wiki pages", true)
    ins("create_forum_post", "Permission to create new forum posts", true)
    ins("create_event", "Permission to create new events", true)
    ins("create_topic_comment", "Permission to comment forum topics", true)
    ins("create_event_comment", "Permission to comment events", true)
  end

  def down do
    del("read_wiki")
    del("create_wiki_page")
    del("modify_wiki")
    del("read_forum")
    del("read_event")
    del("create_wiki")
    del("create_forum_post")
    del("create_event")
    del("create_topic_comment")
    del("create_event_comment")
  end

  defp ins(name, description, login) do
    %PermissionSchema{
      name: name,
      description: description,
      require_login: login
    } |> Repo.insert!()
  end

  defp del(name) do
    case Repo.get_by(Categories, name: name) do
      nil -> nil
      perm -> Repo.delete!(perm)
    end
  end
end
