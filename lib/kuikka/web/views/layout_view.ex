defmodule Kuikka.Web.LayoutView do
  use Kuikka.Web, :view

  alias Kuikka.Repo
  alias Kuikka.Wiki
  alias Kuikka.Web.Gettext, as: KGettext

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

  @spec title(Plug.Conn.t | list) :: String.t
  def title([]), do: "home"
  def title([page]), do: page
  def title([page | _]), do: page
  def title(conn),
    do: Gettext.dgettext(KGettext, "header", title(conn.path_info))
end
