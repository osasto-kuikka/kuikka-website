defmodule KuikkaWebsite.Web.Page.HomeView do
  use KuikkaWebsite.Web, :view

  def render_homepage(%{type: %{name: "markdown"}, content: content}) do
    content
    |> Earmark.as_html!()
    |> raw()
    |> html_escape()
  end
  def render_homepage(%{type: %{name: "html"}, content: content}) do
    content
    |> raw()
    |> html_escape()
  end
end
