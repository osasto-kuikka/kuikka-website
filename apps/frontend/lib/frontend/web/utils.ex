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
  def get_next_event_date do
    date = Timex.now()
    date = case Timex.weekday(date) do
      1 -> Timex.add(date, Duration.from_days(2))
      2 -> Timex.add(date, Duration.from_days(1))
      3 -> date
      4 -> Timex.add(date, Duration.from_days(3))
      5 -> Timex.add(date, Duration.from_days(2))
      6 -> Timex.add(date, Duration.from_days(1))
      7 -> date
    end

    "#{date.day}.#{date.month}.#{date.year}"
  end
end
