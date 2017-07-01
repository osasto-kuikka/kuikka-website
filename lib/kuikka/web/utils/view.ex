defmodule Kuikka.Web.Utils.View do
  @moduledoc """
  Helper functions for frontend modules/templates
  """
  use Phoenix.HTML
  require Kuikka.Web.Gettext

  alias Phoenix.HTML.Form
  alias Kuikka.Web.Gettext, as: KGettext

  @doc """
  Localize and capitalize message

  ## Example
  ```
  En: Gettext.capitalize("test") => "Test"
  Fi: Gettext.capitalize("test") => "Testi"

  En: Gettext.capitalize("default", "test") => "Test"
  Fi: Gettext.capitalize("default", "test") => "Testi"
  ```
  """
  @spec capitalize(String.t) :: String.t
  @spec capitalize(String.t, String.t) :: String.t
  @spec capitalize(String.t, String.t, keyword) :: String.t
  def capitalize(msg),
    do: KGettext |> Gettext.gettext(msg) |> String.capitalize()
  def capitalize(dom, msg, opts \\ []),
    do: KGettext |> Gettext.dgettext(dom, msg, opts) |> String.capitalize()

  @doc """
  Add more sensible values to datetime select
  """
  @spec custom_datetime_select(Form.t, atom, DateTime.t) :: Keyword.t
  def custom_datetime_select(form, field, time) do
    date = DateTime.utc_now()
    builder = fn b ->
      ~E"""
      <%= Kuikka.Web.Gettext.dgettext("editor", "Time") %>:
        <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
      <%= Kuikka.Web.Gettext.dgettext("editor", "Date") %>:
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
    Enum.map(Keyword.get_values(form.errors, field), fn err ->
      content_tag :span, translate_error(err), class: ""
    end)
  end

  @doc """
  Translates an error message using gettext
  """
  @spec translate_error({String.t, Keyword.t}) :: String.t
  def translate_error({msg, opts}) do
    capitalize("errors", msg, opts)
  end
end
