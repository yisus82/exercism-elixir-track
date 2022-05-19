defmodule RPNCalculator do
  @moduledoc """
  An experimental Reverse Polish Notation [RPN] calculator written in Elixir.
  Functions which wrap the operation function so that the errors can be handled more elegantly
  with idiomatic Elixir code.
  """

  @doc """
  The operation function is defined elsewhere, but it can either complete successfully or raise an error.
  Calls the operation function with the stack as the only argument.
  """
  @spec calculate!(list, (list -> :ok | no_return)) :: :ok | no_return
  def calculate!(stack, operation), do: operation.(stack)

  @doc """
  Uses atoms and tuples to indicate their success/failure.
  """
  @spec calculate(list, (list -> {:ok, String.t()} | no_return)) :: {:ok, String.t()} | :error
  def calculate(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      _error -> :error
    end
  end

  @doc """
  Returns also the error message
  """
  @spec calculate_verbose(list, (list -> {:ok, String.t()} | no_return)) ::
          {:ok, String.t()} | {:error, String.t()}
  def calculate_verbose(stack, operation) do
    try do
      calculate!(stack, operation)
      {:ok, "operation completed"}
    rescue
      error -> {:error, error.message}
    end
  end
end
