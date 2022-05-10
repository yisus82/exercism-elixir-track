defmodule FreelancerRates do
  @moduledoc """
  Code to help a freelancer communicate with a project manager
  by providing a few utilities to quickly calculate daily and
  monthly rates, optionally with a given discount.

  We first establish a few rules between the freelancer and the project manager:
    * The daily rate is 8 times the hourly rate.
    * A month has 22 billable days.

  The freelancer is offering to apply a discount if the project manager
  chooses to let the freelancer bill per month, which can come in handy
  if there is a certain budget the project manager has to work with.

  Discounts are modeled as fractional numbers representing percentage, for example `25.0` (25%).
  """

  @daily_rate_ratio 8.0
  @billable_days_per_month 22

  @doc """
  Calculates the daily rate given an hourly rate.
  """
  @spec daily_rate(number) :: float
  def daily_rate(hourly_rate), do: @daily_rate_ratio * hourly_rate

  @doc """
  Calculates the price after a discount.
  """
  @spec apply_discount(number, number) :: float
  def apply_discount(before_discount, discount), do: before_discount * (100 - discount) / 100.0

  @doc """
  Calculates the monthly rate, and apply a discount.
  The returned monthly rate will be rounded up to the nearest integer.
  """
  @spec monthly_rate(number, number) :: integer
  def monthly_rate(hourly_rate, discount),
    do:
      hourly_rate
      |> daily_rate
      |> Kernel.*(@billable_days_per_month)
      |> apply_discount(discount)
      |> Float.ceil()
      |> trunc

  @doc """
  Takes a budget, an hourly rate, and a discount, and calculates how many days of work that covers.
  The returned number of days will be rounded down to one decimal place.
  """
  @spec days_in_budget(number, number, number) :: float
  def days_in_budget(budget, hourly_rate, discount),
    do:
      budget
      |> Kernel./(hourly_rate |> monthly_rate(discount))
      |> Kernel.*(@billable_days_per_month)
      |> Float.floor(1)
end
