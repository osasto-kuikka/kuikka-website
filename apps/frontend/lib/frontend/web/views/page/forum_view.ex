defmodule Frontend.Page.ForumView do
  use Frontend.Web, :view
  alias Phoenix.HTML

  @doc """
  Convert markdown to html
  """
  @spec markdown_to_html(binary) :: binary
  def markdown_to_html(markdown) do
    markdown
    |> Earmark.to_html()
    |> raw
    |> HTML.html_escape()
  end
end
