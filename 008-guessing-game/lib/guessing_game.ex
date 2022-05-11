defmodule GuessingGame do
  @moduledoc """
  Trivial online game where an user can guess a secret number.
  The game will give some feedback, but won't give away the answer with a guess.
  """

  @doc """
  Takes to arguments: the secret number and the user guess.
  Returns a message, according to these rules:
  | Condition                                                     | Response       |
  | ------------------------------------------------------------- | -------------- |
  | When the guess matches the secret number                      | `Correct`      |
  | When the guess is one more or one less than the secret number | `So close`     |
  | When the guess is greater than the secret number              | `Too high`     |
  | When the guess is less than the secret number                 | `Too low`      |
  | When a guess isn't made                                       | `Make a guess` |
  """
  @spec compare(integer, integer | :no_guess) :: String.t()
  def compare(secret_number, guess \\ :no_guess)

  def compare(_secret_number, :no_guess), do: "Make a guess"

  def compare(secret_number, secret_number), do: "Correct"

  def compare(secret_number, guess) when guess == secret_number + 1 or guess == secret_number - 1,
    do: "So close"

  def compare(secret_number, guess) when guess > secret_number, do: "Too high"

  def compare(secret_number, guess) when guess < secret_number, do: "Too low"
end
