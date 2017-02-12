defmodule Frontend.Page.WikiView do
  use Frontend.Web, :view
  alias Phoenix.HTML

  @doc """
  Convert markdown to html
  """
  @spec markdown_to_html(String.t) :: String.t
  def markdown_to_html(markdown) do
    markdown
    |> Earmark.as_html!()
    |> raw()
    |> HTML.html_escape()
  end
end
