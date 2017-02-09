defmodule Frontend.ErrorView do
  use Frontend.Web, :view

  @spec render(String.t, term) :: String.t
  def render("404.html", _assigns) do
    "Page not found"
  end
  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  @spec template_not_found(term, Map.t) :: term
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
