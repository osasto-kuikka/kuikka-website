defmodule KuikkaWebsite.Web.LayoutView do
  use KuikkaWebsite.Web, :view

  alias KuikkaWebsite.Repo
  alias KuikkaWebsite.Wiki

  @doc """
  Render different types of content to html format
  """
  @spec render_page(map) :: Phoenix.HTML.safe
  def render_page(%{type: %{name: "markdown"}, content: content}) do
    content
    |> Earmark.as_html!()
    |> raw()
    |> html_escape()
  end
  def render_page(%{type: %{name: "html"}, content: content}) do
    content
    |> raw()
    |> html_escape()
  end

  def wiki_pages do
    Wiki
    #|> preload()
    |> Repo.all()
    |> case do
      [] -> nil
      pages -> pages
    end
  end
end
