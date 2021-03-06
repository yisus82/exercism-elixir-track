defmodule NewPassport do
  @moduledoc """
  Your passport is about to expire, so you need to drop by the city office to renew it.
  You know from previous experience that your city office is not necessarily the easiest
  to deal with, so you decide to do your best to always "focus on the happy path".
  You print out the form you need to get your new passport, fill it out, jump into your car,
  drive around the block, park and head to the office.
  """

  @fifteen_minutes 15 * 60
  @spec get_new_passport(%NaiveDateTime{}, %NaiveDateTime{}, atom) ::
          {:ok, String.t()} | {:error, String.t()} | {:retry, %NaiveDateTime{}}
  def get_new_passport(now, birthday, form) do
    with {:ok, timestamp} <- enter_building(now),
         {:ok, manual} <- find_counter_information(now),
         counter <- manual.(birthday),
         {:ok, checksum} <- stamp_form(timestamp, counter, form),
         passport_number <- get_new_passport_number(timestamp, counter, checksum) do
      {:ok, passport_number}
    else
      {:error, message} -> {:error, message}
      {:coffee_break, _instructions} -> {:retry, NaiveDateTime.add(now, @fifteen_minutes)}
    end
  end

  defp enter_building(%NaiveDateTime{} = datetime) do
    day = Date.day_of_week(datetime)
    time = NaiveDateTime.to_time(datetime)

    cond do
      day <= 4 and time_between(time, ~T[13:00:00], ~T[15:30:00]) ->
        {:ok, datetime |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()}

      day == 5 and time_between(time, ~T[13:00:00], ~T[14:30:00]) ->
        {:ok, datetime |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix()}

      true ->
        {:error, "city office is closed"}
    end
  end

  @eighteen_years 18 * 365
  defp find_counter_information(%NaiveDateTime{} = datetime) do
    time = NaiveDateTime.to_time(datetime)

    if time_between(time, ~T[14:00:00], ~T[14:20:00]) do
      {:coffee_break, "information counter staff on coffee break, come back in 15 minutes"}
    else
      {:ok, fn %Date{} = birthday -> 1 + div(Date.diff(datetime, birthday), @eighteen_years) end}
    end
  end

  defp stamp_form(timestamp, counter, :blue) when rem(counter, 2) == 1 do
    {:ok, 3 * (timestamp + counter) + 1}
  end

  defp stamp_form(timestamp, counter, :red) when rem(counter, 2) == 0 do
    {:ok, div(timestamp + counter, 2)}
  end

  defp stamp_form(_timestamp, _counter, _form), do: {:error, "wrong form color"}

  defp get_new_passport_number(timestamp, counter, checksum) do
    "#{timestamp}-#{counter}-#{checksum}"
  end

  defp time_between(time, from, to) do
    Time.compare(from, time) != :gt and Time.compare(to, time) == :gt
  end
end
