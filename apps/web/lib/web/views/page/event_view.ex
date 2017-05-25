defmodule Web.Page.EventView do
  use Web, :view
  alias Phoenix.HTML

  alias KuikkaDB.EventSchema

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

  @doc """
  Get list of events for event list view
  """
  @spec get_events() :: [EventSchema.t]
  def get_events do
    EventSchema
    |> Repo.all()
  end

  @doc """
  Get years for datetime select
  """
  @spec get_datetime_options() :: Keyword.t
  def get_datetime_options do
    now = Timex.now()
    five_years = Timex.shift(now, years: 5)
    end_month = Timex.set(now, month: 12)
    [
      year: [options: now.year..five_years.year],
      month: [options: now.month..end_month.month],
      builder: datetime_builder()
    ]
  end
  defp datetime_builder do
    fn b ->
      ~e"""
      <%= Web.Gettext.dgettext("editor", "Date") %>:
      <%= b.(:day, []) %> / <%= b.(:month, []) %> / <%= b.(:year, []) %>
      <%= Web.Gettext.dgettext("editor", "Time") %>:
      <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      """
    end
  end

  @doc """
  Get event
  """
  @spec get_event(Plug.Conn.t) :: EventSchema.t
  def get_event(%{params: %{"id" => id}}) do
    EventSchema
    |> where([e], e.id == ^id)
    |> preload([comments: [:user]])
    |> Repo.one()
    |> case do
      nil -> nil
      event ->
        %{event |
          comments: Enum.map(event.comments, fn c ->
            %{c | user: User.add_profile(c.user)}
          end)
        }
    end
  end
end
