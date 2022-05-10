defmodule Lasagna do
  @moduledoc """
  Some code to help you cook a brilliant lasagna from your favorite cooking book
  """

  @doc """
  Does not take any arguments and returns how many minutes the lasagna should be in the oven.
  According to the cooking book, the expected oven time in minutes is 40.
  """
  @spec expected_minutes_in_oven :: number
  def expected_minutes_in_oven(), do: 40

  @doc """
  Takes the actual minutes the lasagna has been in the oven as an argument
  and returns how many minutes the lasagna still has to remain in the oven,
  based on the expected oven time in minutes.
  """
  @spec remaining_minutes_in_oven(number) :: number
  def remaining_minutes_in_oven(minutes), do: expected_minutes_in_oven() - minutes

  @doc """
  Takes the number of layers you added to the lasagna as an argument
  and returns how many minutes you spent preparing the lasagna,
  assuming each layer takes you 2 minutes to prepare.
  """
  @spec preparation_time_in_minutes(number) :: number
  def preparation_time_in_minutes(num_layers), do: 2 * num_layers

  @doc """
  Takes two arguments: the number of layers you added to the lasagna
  and the number of minutes the lasagna has been in the oven.
  The function returns how many minutes in total you've worked on
  cooking the lasagna, which is the sum of the preparation time in minutes,
  and the time in minutes the lasagna has spent in the oven at the moment.
  """
  @spec total_time_in_minutes(number, number) :: number
  def total_time_in_minutes(num_layers, minutes_in_oven),
    do: preparation_time_in_minutes(num_layers) + minutes_in_oven

  @doc """
  Does not take any arguments and returns a message indicating
  that the lasagna is ready to eat.
  """
  @spec alarm :: String.t()
  def alarm(), do: "Ding!"
end
