defmodule BirdCount do
  @moduledoc """
  Function to help track and process the data of bird watching sessions.

  The data will be stored as a list of integers.
  The first number in the list is the number of birds that visited the garden today,
  the second yesterday, and so on.
  """

  @doc """
  Takes a list of daily bird counts and return today's count.
  If the list is empty, returns `nil`
  """
  @spec today([non_neg_integer]) :: nil | non_neg_integer
  def today([]), do: nil

  def today([head | _tail]), do: head

  @doc """
  Takes a list of daily bird counts and increments the today's count by 1.
  If the list is empty, returns `[1]`.
  """
  @spec increment_day_count([non_neg_integer]) :: [non_neg_integer]
  def increment_day_count([]), do: [1]

  def increment_day_count([head | tail]), do: [head + 1 | tail]

  @doc """
  Takes a list of daily bird counts.
  Returns `true` if there was at least one day when no birds visited the garden, and `false` otherwise.
  """
  @spec has_day_without_birds?([non_neg_integer]) :: boolean
  def has_day_without_birds?([]), do: false

  def has_day_without_birds?([head | tail]), do: head == 0 or has_day_without_birds?(tail)

  @doc """
  Takes a list of daily bird counts.
  Returns the total number of birds that visited the garden since the start of data collection.
  """
  @spec total([non_neg_integer]) :: non_neg_integer
  def total([]), do: 0

  def total([head | tail]), do: head + total(tail)

  @doc """
  Takes a list of daily bird counts and returns the number of busy days.
  A busy day is one where five or more birds have visited the garden.
  """
  @spec busy_days([non_neg_integer]) :: non_neg_integer
  def busy_days([]), do: 0

  def busy_days([head | tail]) when head >= 5, do: 1 + busy_days(tail)

  def busy_days([head | tail]) when head < 5, do: busy_days(tail)
end
