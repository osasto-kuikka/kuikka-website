defmodule Web.LayoutView do
  use Web, :view

  @doc """
  Check if current tab is active tab
  """
  @spec active_tab(Plug.Conn.t, List.t) :: String.t
  def active_tab(%{params: %{"tab" => current_tab}}, %{name: name}) do
    if current_tab == name do
      "is-active"
    end
  end
  def active_tab(%{assigns: %{tab: current_tab}}, %{name: name}) do
    if current_tab == name do
      "is-active"
    end
  end
  def active_tab(_conn, %{default: true}) do
    "is-active"
  end
  def active_tab(_conn, _tab) do
    ""
  end
end
