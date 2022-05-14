defmodule BasketballWebsite do
  @moduledoc """
  Functions to be able to extract data from a series of nested maps to facilitate rapid development.
  """

  @doc """
  Takes two arguments: a nested map structure with data about the basketball team,
  and a string consisting of period-delimited keys to obtain the value associated with the last key.
  If the value or the key does not exist at any point in the path, returns `nil`
  """
  @spec extract_from_path(map, String.t()) :: any
  def extract_from_path(data, path),
    do: Enum.reduce(String.split(path, "."), data, fn key, acc -> acc[key] end)

  @doc """
  Takes two arguments: a nested map structure with data about the basketball team,
  and a string consisting of period-delimited keys to obtain the value associated with the last key.
  If the value or the key does not exist at any point in the path, returns `nil`
  """
  @spec get_in_path(map, String.t()) :: any
  def get_in_path(data, path), do: Kernel.get_in(data, String.split(path, "."))
end
