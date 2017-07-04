defmodule Kuikka.Web.ForumView do
  use Kuikka.Web, :view
  alias Kuikka.Forum.Topic

  def forum_topics do
    Topic
    #|> preload()
    |> Repo.all()
    |> case do
      [] -> nil
      topics -> topics
    end
  end
end
