defmodule KuikkaWebsite.Web.ErrorView do
  use KuikkaWebsite.Web, :view

  @spec render(String.t, map) :: String.t
  def render("404.html", _assigns) do
    "Page not found"
  end
  def render("500.html", _assigns) do
    "Internal server error"
  end
end
