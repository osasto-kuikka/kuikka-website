defmodule KuikkaWeb.Utils.View do
  @moduledoc """
  Helper functions for frontend modules/templates
  """
  use Phoenix.HTML
  require KuikkaWeb.Gettext
  require Logger

  alias Phoenix.HTML
  alias Phoenix.HTML.Form
  alias KuikkaWeb.Gettext, as: KGettext

  @doc """
  Add more sensible values to datetime select
  """
  @spec custom_datetime_select(Form.t, atom) :: HTML.safe
  def custom_datetime_select(form = %Form{}, field) when is_atom(field) do
    now = DateTime.utc_now()
    time = Map.get(form.source.changes, field) || now
    builder = fn b ->
      ~E"""
      <div class="select">
        <%= b.(:hour, []) %>
      </div>
      <div class="select">
        <%= b.(:minute, []) %>
      </div>
      <div class="select">
        <%= b.(:day, []) %>
      </div>
      <div class="select">
        <%= b.(:month, []) %>
      </div>
      <div class="select">
        <%= b.(:year, []) %>
      </div>
      """
    end

    opts = [
      month: [options: Range.new(1, 12)],
      year: [options: Range.new(now.year, now.year + 5)],
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
    "#{pad(date.hour)}:#{pad(date.minute)} " <> to_date(date)
  end

  # Add zero before value if value is smaller than 10
  @spec pad(integer) :: String.t
  defp pad(int) when int > 10, do: "#{int}"
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
      msg = "#{field} #{translate_error(err)}"
      content_tag :span, msg, class: "capitalize color--red"
    end)
  end

  @doc """
  Translates an error message using gettext
  """
  @spec translate_error({String.t, Keyword.t}) :: String.t
  def translate_error({msg, opts}) do
    Gettext.dgettext(KGettext, "errors", msg, opts)
  end

  @doc """
  Render markdown text as html
  """
  @spec markdown(String.t) :: HTML.safe
  def markdown(content) do
    case Earmark.as_html(content) do
      {:ok, html, _errors} ->
        HTML.raw(html)

      {:err, err} ->
        Logger.error(inspect err)
        content
    end
  end
end
