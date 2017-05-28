defmodule KuikkaWebsite.Web.LayoutView do
  use KuikkaWebsite.Web, :view

  @type page :: KuikkaWebsite.Page |
                KuikkaWebsite.Page.Home |
                KuikkaWebsite.Page.Layout

  @doc """
  Render different types of content to html format
  """
  @spec render_page(page) :: Phoenix.HTML.safe
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
end
