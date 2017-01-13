defmodule Frontend.Utils do
  @moduledoc """
  Helper functions for frontend modules/templates
  """
  alias Timex.Duration

  @doc """
  Get date of next event by getting current date and showing either
  wednesday or sunday.

  TODO: Proper event query when we get events implemented
  """
  @spec get_next_event_date() :: String.t
  def get_next_event_date do
    date = Timex.now()

    date
    |> Timex.weekday()
    |> case do
      1 -> Timex.add(date, Duration.from_days(2))
      2 -> Timex.add(date, Duration.from_days(1))
      3 -> date
      4 -> Timex.add(date, Duration.from_days(3))
      5 -> Timex.add(date, Duration.from_days(2))
      6 -> Timex.add(date, Duration.from_days(1))
      7 -> date
    end
    |> to_date()
  end

  @doc """
  Transform raw datetime to prettier date
  """
  @spec to_date(DateTime.t) :: String.t
  def to_date(date) do
    "#{date.day}.#{date.month}.#{date.year}"
  end
end
