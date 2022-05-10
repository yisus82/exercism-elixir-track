defmodule Rules do
  @moduledoc """
  Translates some rules from the classic game Pac-Man into Elixir functions.
  """

  @doc """
  Takes two arguments: if Pac-Man has a power pellet active and if Pac-Man is touching a ghost.
  Returns a boolean value if Pac-Man is able to eat the ghost.
  The function returns true only if Pac-Man has a power pellet active and is touching a ghost.
  """
  @spec eat_ghost?(boolean, boolean) :: boolean
  def eat_ghost?(power_pellet_active?, touching_ghost?),
    do: power_pellet_active? and touching_ghost?

  @doc """
  Takes two arguments: if Pac-Man is touching a power pellet and if Pac-Man is touching a dot.
  Returns a boolean value if Pac-Man scored.
  The function returns true if Pac-Man is touching a power pellet or a dot.
  """
  @spec score?(boolean, boolean) :: boolean
  def score?(touching_power_pellet?, touching_dot?), do: touching_power_pellet? or touching_dot?

  @doc """
  Takes two arguments: if Pac-Man has a power pellet active and if Pac-Man is touching a ghost.
  Returns a boolean value if Pac-Man loses.
  The function returns true if Pac-Man is touching a ghost and does not have a power pellet active.
  """
  @spec lose?(boolean, boolean) :: boolean
  def lose?(power_pellet_active?, touching_ghost?),
    do: touching_ghost? and not power_pellet_active?

  @doc """
  Takes three arguments: if Pac-Man has eaten all of the dots, if Pac-Man has a power pellet active,
  and if Pac-Man is touching a ghost.
  Returns a boolean value if Pac-Man wins.
  The function returns true if Pac-Man has eaten all of the dots and has not lost.
  """
  @spec win?(boolean, boolean, boolean) :: boolean
  def win?(has_eaten_all_dots?, power_pellet_active?, touching_ghost?),
    do: has_eaten_all_dots? and not lose?(power_pellet_active?, touching_ghost?)
end
