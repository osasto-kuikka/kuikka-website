defmodule KuikkaWebsite.Web.Gettext do
  @moduledoc """
  A module providing Internationalization with a gettext-based API.

  By using [Gettext](https://hexdocs.pm/gettext),
  your module gains a set of macros for translations, for example:

      import KuikkaWebsite.Web.Gettext

      # Simple translation
      gettext "Here is the string to translate"

      # Plural translation
      ngettext "Here is the string to translate",
               "Here are the strings to translate",
               3

      # Domain-based translation
      dgettext "errors", "Here is the error message to translate"

  See the [Gettext Docs](https://hexdocs.pm/gettext) for detailed usage.
  """
  use Gettext, otp_app: :kuikka_website

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
  @spec capitalize(String.t, String.t, String.t, integer, keyword) :: String.t
  def capitalize(msg),
    do: msg |> __MODULE__.gettext() |> String.capitalize()
  def capitalize(dom, msg),
    do: dom |> __MODULE__.dgettext(msg) |> String.capitalize()
  def capitalize(dom, msg, opts),
    do: dom |> __MODULE__.dngettext(msg, opts) |> String.capitalize()
  def capitalize(dom, msg, msg, count, opts),
    do: dom |> __MODULE__.dngettext(msg, msg, count, opts) |> String.capitalize()
end
