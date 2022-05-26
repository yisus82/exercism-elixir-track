defmodule ResistorColor do
  @moduledoc """
  Module to look up the numerical value associated with a particular color band associated with resistors
  """

  @color_bands %{
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  }

  @doc """
  Returns the value of a color band
  """
  @spec code(atom) :: integer
  def code(color), do: @color_bands[color]
end
