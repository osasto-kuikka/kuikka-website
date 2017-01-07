defmodule Frontend.Page.HomeView do
  use Frontend.Web, :view

  alias Calendar.{Date, DateTime}

  @doc """
  Get date of next event by getting current date and showing either
  wednesday or sunday.

  TODO: Proper event query when we get events implemented
  """
  def get_next_event_date do
    date = DateTime.now_utc() |> DateTime.to_date()
    date = case Date.day_of_week(date) do
      1 -> Date.advance!(date, 2)
      2 -> Date.advance!(date, 1)
      3 -> date
      4 -> Date.advance!(date, 3)
      5 -> Date.advance!(date, 2)
      6 -> Date.advance!(date, 1)
      7 -> date
    end

    "#{date.day}.#{date.month}.#{date.year}"
  end
end
