defmodule KuikkaWebsite.Web.Utils.View do
  @moduledoc """
  Helper functions for frontend modules/templates
  """
  use Phoenix.HTML

  alias Phoenix.HTML.Form
  alias KuikkaWebsite.Web.Gettext

  @doc """
  Add more sensible values to datetime select
  """
  @spec custom_datetime_select(Form.t, atom, DateTime.t) :: Keyword.t
  def custom_datetime_select(form, field, time) do
    date = DateTime.utc_now()
    builder = fn b ->
      ~E"""
      <%= KuikkaWebsite.Web.Gettext.dgettext("editor", "Time") %>:
        <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      <%= KuikkaWebsite.Web.Gettext.dgettext("editor", "Date") %>:
        <%= b.(:day, []) %> / <%= b.(:month, []) %> / <%= b.(:year, []) %>
      """
    end

    opts = [
      year: [options: Range.new(1, 12)],
      month: [options: Range.new(date.year, date.year + 5)],
      value: time,
      builder: builder
    ]

    Form.datetime_select(form, field, opts)
  end

  @doc """
  Transform raw datetime to prettier date
  """
  @spec to_date(DateTime.t) :: String.t
  def to_date(date) do
    "#{pad(date.day)}.#{pad(date.month)}.#{date.year}"
  end

  @doc """
  Transform raw datetime to prettier date and time
  """
  @spec to_date_time(DateTime.t) :: String.t
  def to_date_time(date) do
    "#{pad(date.hour)}:#{date.minute} " <>
    "#{pad(date.day)}.#{pad(date.month)}.#{date.year}"
  end

  # Add zero before value if value is smaller than 10
  @spec pad(integer) :: String.t
  defp pad(int) when int < 10, do: "#{int}"
  defp pad(int), do: "0#{int}"

  @doc """
  Check if user has required permission
  """
  @spec has_permission?(Plug.Conn.t, String.t) :: boolean
  def has_permission?(%{assigns: %{permissions: perms}}, permission) do
    Enum.member?(perms, permission)
  end

  @doc """
  Generates tag for inlined form input errors
  """
  @spec error_tag(Phoenix.HTML.From, atom) :: [String.t]
  def error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn (error) ->
      content_tag :span, translate_error(error), class: ""
    end)
  end

  @doc """
  Translates an error message using gettext
  """
  @spec translate_error({String.t, Keyword.t}) :: String.t
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.capitalize("errors", msg, msg, count, opts)
    else
      Gettext.capitalize("errors", msg, opts)
    end
  end
end
