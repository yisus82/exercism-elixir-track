defmodule LibraryFees do
  @moduledoc """
  Module to extend a library software to automatically calculate late fees.
  The current system stores the exact date and time of a book checkout as an ISO8601 datetime string.
  It uses the GMT timezone (UTC +0), doesn't use daylight saving time,
  and doesn't need to worry about other timezones.
  """

  @doc """
  Takes an `ISO8601` datetime string as an argument, and returns a `NaiveDateTime` struct.
  """
  @spec datetime_from_string(String.t()) ::
          NaiveDateTime.t()
  def datetime_from_string(string), do: NaiveDateTime.from_iso8601!(string)

  @doc """
  Takes a `NaiveDateTime` struct and returns a boolean if the hour is less than 12 AM.
  """
  @spec before_noon?(NaiveDateTime.t()) :: boolean
  def before_noon?(datetime), do: datetime.hour < 12

  @doc """
  Take a `NaiveDateTime` struct and returns a `Date` struct, either 28 or 29 days later.
  If a book was checked out before noon, the reader has 28 days to return it.
  If it was checked out at or after noon, it's 29 days.
  """
  @spec return_date(NaiveDateTime.t()) :: Date.t()
  def return_date(checkout_datetime) do
    days_to_return = if before_noon?(checkout_datetime), do: 28, else: 29
    Date.add(checkout_datetime, days_to_return)
  end

  @doc """
  Takes the planned return datetime as a `Date` struct, and the actual return datetime
  as a `NaiveDateTime` struct.

  If the actual return date is on an earlier or the same day as the planned return datetime,
  the function returns 0.
  Otherwise, the function returns the difference between those two dates in days.

  The library tracks both the date and time of the actual return of the book for statistical purposes,
  but doesn't use the time when calculating late fees.
  """
  @spec days_late(Date.t(), NaiveDateTime.t()) :: non_neg_integer
  def days_late(planned_return_date, actual_return_datetime) do
    days_diff = Date.diff(actual_return_datetime, planned_return_date)
    if days_diff < 0, do: 0, else: days_diff
  end

  @doc """
  Takes a `NaiveDateTime` struct and returns a boolean if the day of the week is Monday.
  """
  @spec monday?(NaiveDateTime.t()) :: boolean
  def monday?(datetime), do: Date.day_of_week(datetime) == 1

  @doc """
  Takes three arguments: two `ISO8601` datetime strings (checkout datetime and actual return datetime),
  and the late fee for one day.
  Returns the total late fee according to how late the actual return of the book was.
  If you return the book on Monday, your late fee is 50% off, rounded down.
  """
  @spec calculate_late_fee(String.t(), String.t(), number) :: number
  def calculate_late_fee(checkout, return, rate) do
    checkout_datetime = datetime_from_string(checkout)
    planned_return_date = return_date(checkout_datetime)
    actual_return_datetime = datetime_from_string(return)
    days_late = days_late(planned_return_date, actual_return_datetime)
    late_fee = days_late * rate
    is_monday? = monday?(actual_return_datetime)
    if is_monday?, do: floor(late_fee * 0.5), else: late_fee
  end
end
