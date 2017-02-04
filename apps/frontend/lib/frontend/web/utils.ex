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
  @spec get_next_event_date() :: binary
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
    date = transform_to_date(date)
    Timex.format!(date, "{0D}.{0M}.{YYYY}")
  end

  @doc """
  Transform raw datetime to prettier date and time
  """
  @spec to_date(DateTime.t) :: String.t
  def to_date_time(date) do
    date = transform_to_date(date)
    Timex.format!(date, "{h24}:{0m} {0D}.{0M}.{YYYY}")
  end

  defp transform_to_date({{d,m,y}, {t1,t2,t3,_}}) do
    Timex.to_datetime({{d,m,y},{t1,t2,t3}})
  end
  defp transform_to_date(date = {{_,_,_}, {_,_,_,}}) do
    Timex.to_datetime(date)
  end
  defp transform_to_date(date) do
    date
  end
end
