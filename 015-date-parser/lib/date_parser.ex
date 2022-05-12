defmodule DateParser do
  @moduledoc """
  Functions to use in a service which ingests events.
  Each event has a date associated with it, but 3 different formats
  are being submitted to the service's endpoint:
    * "01/01/1970"
    * "January 1, 1970"
    * "Thursday, January 1, 1970"
  """

  @doc """
  Returns a string pattern which, when compiled, would match the numeric components
  in "01/01/1970" (dd/mm/yyyy).
  The day may appear as 1 or 01 (left padded with zeroes).
  """
  @spec day :: String.pattern()
  def day(), do: "([0]?[1-9]|[1-2][0-9]|30|31)"

  @doc """
  Returns a string pattern which, when compiled, would match the numeric components
  in "01/01/1970" (dd/mm/yyyy).
  The month may appear as 1 or 01 (left padded with zeroes).
  """
  @spec month :: String.pattern()
  def month(), do: "([0]?[1-9]|1[0-2])"

  @doc """
  Returns a string pattern which, when compiled, would match the numeric components
  in "01/01/1970" (dd/mm/yyyy).
  """
  @spec year :: String.pattern()
  def year(), do: "([1-9][0-9]{3})"

  @doc """
  Returns a string pattern which, when compiled, would match the named day of the week.
  """
  @spec day_names :: String.pattern()
  def day_names(), do: "(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday)"

  @doc """
  Returns a string pattern which, when compiled, would match the named month of the year.
  """
  @spec month_names :: String.pattern()
  def month_names(),
    do: "(January|February|March|April|May|June|July|August|September|October|November|December)"

  @doc """
  Returns a string pattern which captures the day component to the name `day`.
  """
  @spec capture_day :: String.pattern()
  def capture_day(), do: "(?<day>" <> day() <> ")"

  @doc """
  Returns a string pattern which captures the month component to the name `month`.
  """
  @spec capture_month :: String.pattern()
  def capture_month(), do: "(?<month>" <> month() <> ")"

  @doc """
  Returns a string pattern which captures the year component to the name `year`.
  """
  @spec capture_year :: String.pattern()
  def capture_year(), do: "(?<year>" <> year() <> ")"

  @doc """
  Returns a string pattern which captures the day_name component to the name `day_name`.
  """
  @spec capture_day_name :: String.pattern()
  def capture_day_name(), do: "(?<day_name>" <> day_names() <> ")"

  @doc """
  Returns a string pattern which captures the month_name component to the name `month_name`.
  """
  @spec capture_month_name :: String.pattern()
  def capture_month_name(), do: "(?<month_name>" <> month_names() <> ")"

  @doc """
  Returns a string pattern which captures the components using the respective date format.
  """
  @spec capture_numeric_date :: String.pattern()
  def capture_numeric_date(), do: "#{capture_day()}/#{capture_month()}/#{capture_year()}"

  @doc """
  Returns a string pattern which captures the components using the respective date format.
  """
  @spec capture_month_name_date :: String.pattern()
  def capture_month_name_date(), do: "#{capture_month_name()} #{capture_day()}, #{capture_year()}"

  @doc """
  Returns a string pattern which captures the components using the respective date format.
  """
  @spec capture_day_month_name_date :: String.pattern()
  def capture_day_month_name_date(), do: "#{capture_day_name()}, #{capture_month_name_date()}"

  @doc """
  Returns a compiled regular expression that only matches the date,
  and which can also capture the components using the respective date format.
  """
  @spec match_numeric_date :: Regex.t()
  def match_numeric_date(), do: ~r/^#{capture_numeric_date()}$/

  @doc """
  Returns a compiled regular expression that only matches the date,
  and which can also capture the components using the respective date format.
  """
  @spec match_month_name_date :: Regex.t()
  def match_month_name_date(), do: ~r/^#{capture_month_name_date()}$/

  @doc """
  Returns a compiled regular expression that only matches the date,
  and which can also capture the components using the respective date format.
  """
  @spec match_day_month_name_date :: Regex.t()
  def match_day_month_name_date(), do: ~r/^#{capture_day_month_name_date()}$/
end
