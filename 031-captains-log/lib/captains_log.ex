defmodule CaptainsLog do
  @moduledoc """
  Random generators for data commonly appearing in the captain's log from an
  RPG game based on Star Trek: Next Generation TV series.

  The Starship Enterprise encounters many planets in its travels.
  Planets in the Star Trek universe are split into categories based on their properties.
  For example, Earth is a class M planet.
  All possible planetary classes are: D, H, J, K, L, M, N, R, T, and Y.
  """

  @planetary_classes ["D", "H", "J", "K", "L", "M", "N", "R", "T", "Y"]

  @doc """
  Returns one of the planetary classes at random.
  """
  @spec random_planet_class :: String.t()
  def random_planet_class(), do: Enum.random(@planetary_classes)

  @doc """
  Returns a random starship registry number.
  Registry numbers start with the prefix "NCC-" and then use a number from 1000 to 9999 (inclusive).
  """
  @spec random_ship_registry_number :: String.t()
  def random_ship_registry_number(), do: "NCC-#{Enum.random(1000..9999)}"

  @doc """
  A stardate is a floating point number.
  The adventures of the Starship Enterprise from the first season of The Next Generation
  take place between the stardates 41000.0 and 42000.0. The "4" stands for the 24th century,
  the "1" for the first season.
  Returns a floating point number between 41000.0 (inclusive) and 42000.0 (exclusive).
  """
  @spec random_stardate :: float
  def random_stardate(), do: random_float(41000.0, 42000.0)

  @doc """
  Takes a floating point number and returns a string with the number rounded to a single decimal place.
  """
  @spec format_stardate(float) :: String.t()
  def format_stardate(stardate), do: :io_lib.format("~.1f", [stardate]) |> to_string

  defp random_float(min, max), do: min + :rand.uniform() * (max - min)
end
