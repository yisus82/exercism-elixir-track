defmodule RPNCalculator.Exception do
  @moduledoc """
  Module to be able to raise errors that are more specific than the generic errors
  provided by the standard library.
  """

  defmodule DivisionByZeroError do
    @moduledoc """
    Dividing a number by zero produces an undefined result,
    which the team decides is best represented by an error.
    """
    defexception message: "division by zero occurred"
  end

  defmodule StackUnderflowError do
    @moduledoc """
    RPN calculators use a stack to keep track of numbers before they are added.
    The team represents this stack with a list of numbers (integer and floating-point), e.g.: `[3, 4.0]`.
    Each operation needs a specific number of numbers on the stack in order to perform its calculation.
    When there are not enough numbers on the stack, this is called a stack underflow error.
    """

    defexception message: "stack underflow occurred"

    def exception(context) do
      case context do
        [] ->
          %StackUnderflowError{}

        _ ->
          %StackUnderflowError{message: "stack underflow occurred, context: " <> context}
      end
    end
  end

  @doc """
  Takes a stack (list of numbers) and:
  * raises stack underflow when the stack does not contain enough numbers
  * raises division by zero when the divisor is 0 (note the stack of numbers is stored in the reverse order)
  * performs the division when no errors are raised
  """
  @spec divide([integer]) :: number | no_return
  def divide([0 | [_ | _]]), do: raise(DivisionByZeroError)

  def divide([x | [y | _]]), do: y / x

  def divide(_), do: raise(StackUnderflowError, "when dividing")
end
