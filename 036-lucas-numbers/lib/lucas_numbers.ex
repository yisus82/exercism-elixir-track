defmodule LucasNumbers do
  @moduledoc """
  Lucas numbers are an infinite sequence of numbers which build progressively
  which hold a strong correlation to the golden ratio (φ or ϕ)

  E.g.: 2, 1, 3, 4, 7, 11, 18, 29, ...
  """

  @doc """
  Generates a list with the first `count` numbers from the Lucas numbers sequence
  """
  @spec generate(non_neg_integer) :: [non_neg_integer]
  def generate(count) when is_integer(count) and count >= 1 do
    Stream.unfold({2, 1}, fn {x, y} -> {x, {y, x + y}} end)
    |> Enum.take(count)
  end

  def generate(_), do: raise(ArgumentError, "count must be specified as an integer >= 1")
end
