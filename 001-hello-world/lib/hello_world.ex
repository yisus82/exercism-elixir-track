defmodule HelloWorld do
  @moduledoc """
  The classical introductory exercise.
  Just say "Hello, World!".
  """

  @doc """
  Simply returns "Hello, World!"
  """
  @spec hello :: String.t()
  def hello, do: "Hello, World!"
end
