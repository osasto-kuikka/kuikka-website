defmodule Kuikka.Web.ErrorView do
  use Kuikka.Web, :view

  @spec render(String.t, map) :: String.t
  def render("404.html", _assigns) do
    "Page not found"
  end
  def render("500.html", _assigns) do
    "Internal server error"
  end
  def render("505.html", _assigns) do
    "Internal server error"
  end
end
