defmodule Kuikka.Web.HomeView do
  use Kuikka.Web, :view

  alias Kuikka.Web.LayoutView

  defdelegate render_page(page), to: LayoutView
end
