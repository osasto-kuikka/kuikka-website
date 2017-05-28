defmodule KuikkaWebsite.Web.Page.HomeView do
  use KuikkaWebsite.Web, :view

  alias KuikkaWebsite.Web.Page.LayoutView

  defdelegate render_homepage(page), to: LayoutView
end
