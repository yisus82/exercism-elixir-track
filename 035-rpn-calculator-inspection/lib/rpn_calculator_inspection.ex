defmodule RPNCalculatorInspection do
  @moduledoc """
  Functions to conduct two types of checks:
    * A reliability check that will detect inputs for which an RPN calculator under inspection
    either crashes or doesn't respond fast enough. To isolate failures, the calculations for
    each input need to be run in a separate process. Linking and trapping exits in the caller
    process can be used to detect if the calculation finished or crashed.
    * A correctness check that will check if for a given input, the result returned by the calculator
    is as expected. Only calculators that already passed the reliability check will undergo a correctness
    check, so crashes are not a concern. However, the operations should be run concurrently to speed up
    the process, which makes it the perfect use case for asynchronous tasks.
  """
  @spec start_reliability_check(fun, String.t()) :: %{input: String.t(), pid: pid}
  def start_reliability_check(calculator, input),
    do: %{input: input, pid: spawn_link(fn -> calculator.(input) end)}

  @doc """
  Takes two arguments:
    * A map with the input of the reliability check and the PID of the process running the reliability
    check for this input, as returned by `start_reliability_check/2`
    * A map that serves as an accumulator for the results of reliability checks with different inputs

  The function waits for an exit message `{:EXIT, from, reason}`:
    * When the reason is `:normal`, it returns the results map with the value `:ok` added under the key `input`
    * When is a different reason, it returns the results map with the value `:error` added under the key `input`
    * If it doesn't receive any messages within 100ms, it returns the results map with the value `:timeout` added under the key `input`
  """
  @spec await_reliability_check_result(%{input: String.t(), pid: pid}, map) :: map
  def await_reliability_check_result(%{input: input, pid: pid}, results) do
    receive do
      {:EXIT, ^pid, :normal} -> Map.put(results, input, :ok)
      {:EXIT, ^pid, _} -> Map.put(results, input, :error)
    after
      100 -> Map.put(results, input, :timeout)
    end
  end

  @doc """
  Takes 2 arguments: a function (the calculator), and a list of inputs for the calculator.

  For every input on the list, it starts the reliability check in a new linked process by using
  `start_reliability_check/2`. Then, for every process started this way, it awaits its results
  by using `await_reliability_check_result/2`.

  Before starting any processes, the function needs to flag the current process to trap exits,
  to be able to receive exit messages. Afterwards, it resets this flag to its original value.

  The function returns a map with the results of reliability checks of all the inputs.
  """
  @spec reliability_check(fun, [String.t()]) :: map
  def reliability_check(calculator, inputs) do
    trap_flag_before_check = Process.flag(:trap_exit, true)

    inputs
    |> Enum.map(&start_reliability_check(calculator, &1))
    |> Enum.reduce(%{}, &await_reliability_check_result/2)
    |> tap(fn _ -> Process.flag(:trap_exit, trap_flag_before_check) end)
  end

  @doc """
  Takes 2 arguments: a function (the calculator), and a list of inputs for the calculator.

  For every input on the list, it starts an asynchronous task that will call the calculator
  with the given input.
  Then, for every task started this way, it awaits its results for 100ms.
  """
  @spec correctness_check(fun, [String.t()]) :: [any]
  def correctness_check(calculator, inputs),
    do:
      inputs
      |> Enum.map(&Task.async(fn -> calculator.(&1) end))
      |> Enum.map(&Task.await(&1, 100))
end
