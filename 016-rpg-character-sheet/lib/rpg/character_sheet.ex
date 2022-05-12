defmodule RPG.CharacterSheet do
  @moduledoc """
  A small program that will guide new RPG players through the character creation process.
  """

  @doc """
  Prints a welcome message, and returns `:ok`
  """
  @spec welcome :: :ok
  def welcome(), do: IO.puts("Welcome! Let's fill out your character sheet together.")

  @doc """
  Prints a question, waits for an answer, and returns the answer
  without leading and trailing whitespace.
  """
  @spec ask_name :: String.t()
  def ask_name(),
    do:
      IO.gets("What is your character's name?\n")
      |> String.trim()

  @doc """
  Prints a question, waits for an answer, and returns the answer
  without leading and trailing whitespace.
  """
  @spec ask_class :: String.t()
  def ask_class(),
    do:
      IO.gets("What is your character's class?\n")
      |> String.trim()

  @doc """
  Prints a question, waits for an answer, and returns the answer
  as an integer.
  """
  @spec ask_level :: non_neg_integer
  def ask_level(),
    do:
      IO.gets("What is your character's level?\n")
      |> Integer.parse()
      |> elem(0)

  @doc """
  Welcomes the new player, asks for the character's name, class, and level,
  and returns the character sheet as a map.
  It also prints the map with the label `Your character`.
  """
  @spec run :: %{name: String.t(), class: String.t(), level: non_neg_integer}
  def run() do
    welcome()

    %{name: ask_name(), class: ask_class(), level: ask_level()}
    |> IO.inspect(label: "Your character")
  end
end
