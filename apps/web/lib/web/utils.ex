defmodule Web.Utils do
  @moduledoc """
  Helper functions for frontend modules/templates
  """
  import Phoenix.HTML
  require Web.Gettext

  alias Phoenix.HTML.Form
  alias Web.Router.Helpers
  alias Steamex.Auth

  @doc """
  Add more sensible values to datetime select
  """
  @spec custom_datetime_select(Phoenix.HTML.Form.t, atom, DateTime.t) ::
                                                                      Keyword.t
  def custom_datetime_select(form, field, time) do
    date = Timex.now()
    builder = fn b ->
      ~E"""
      <%= Web.Gettext.dgettext("editor", "Time") %>:
        <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      <%= Web.Gettext.dgettext("editor", "Date") %>:
        <%= b.(:day, []) %> / <%= b.(:month, []) %> / <%= b.(:year, []) %>
      """
    end

    opts = []
          |> Keyword.put(:year, [options: Range.new(date.year, date.year + 5)])
          |> Keyword.put(:month, [options: Range.new(1, 12)])
          |> Keyword.put(:value, time)
          |> Keyword.put(:builder, builder)

    Form.datetime_select(form, field, opts)
  end

  @doc """
  Transform raw datetime to prettier date
  """
  @spec to_date(DateTime.t) :: String.t
  def to_date(date) do
    date = transform_to_date(date)
    Timex.format!(date, "{0D}.{0M}.{YYYY}")
  end

  @doc """
  Transform raw datetime to prettier date and time
  """
  @spec to_date_time(DateTime.t) :: String.t
  def to_date_time(date) do
    date = transform_to_date(date)
    Timex.format!(date, "{h24}:{0m} {0D}.{0M}.{YYYY}")
  end

  @spec transform_to_date({term, term}) :: Datetime.t
  defp transform_to_date({{d,m,y}, {t1,t2,t3,_}}),
    do: Timex.to_datetime({{d,m,y},{t1,t2,t3}})
  defp transform_to_date(date = {{_,_,_}, {_,_,_,}}),
    do: Timex.to_datetime(date)
  defp transform_to_date(date),
    do: date

  @doc """
  Generate url for login with steam
  """
  @spec auth_url(Plug.Conn.t) :: String.t
  def auth_url(conn) do
    realm = realm_url(Helpers.url(conn))
    return_to = realm <> "/members?" <> URI.encode_query(%{"login" => "true"})
    Auth.auth_url(realm, return_to)
  end
  defp realm_url("http://localhost:4000"),
    do: "http://localhost:4000"
  defp realm_url(host),
    do: host |> String.split(":") |> Enum.drop(-1) |> Enum.join(":")
end
