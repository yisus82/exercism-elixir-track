defmodule TwoFer do
  @moduledoc """
  Two-fer or 2-fer is short for two for one. One for you and one for me.
  """

  @doc """
  Given a `name`, returns a string with the message: `"One for name, one for me."`
  If the `name` is missing, returns the string: `"One for you, one for me."`
  """
  @spec two_fer(String.t()) :: String.t()
  def two_fer(name \\ "you") when is_binary(name), do: "One for #{name}, one for me."
end
