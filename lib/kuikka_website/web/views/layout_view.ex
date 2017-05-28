defmodule KuikkaWebsite.Web.LayoutView do
  use KuikkaWebsite.Web, :view

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
