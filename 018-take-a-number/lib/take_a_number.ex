defmodule TakeANumber do
  @moduledoc """
  An embedded system for a Take-A-Number machine.
  It is a very simple model.
  It can give out consecutive numbers and report what was the last number given out.

  When the machine receives `{:report_state, sender_pid}` messages, it sends its current state
  to `sender_pid` and then waits for more messages.
  When the machine receives `{:take_a_number, sender_pid}` messages, it increases its state by 1,
  sends the new state to `sender_pid`, and then waits for more messages.
  When the machine receives `:stop` message, it stops waiting for more messages.
  When the machine receives an unexpected message, it ignores it and continues waiting for more messages.
  """

  @doc """
  Spawns a new process that has an initial state of 0 and is ready to receive messages.
  Returns the process's PID.
  """
  @spec start :: pid
  def start(), do: spawn(&loop/0)

  defp loop(state \\ 0) do
    receive do
      {:report_state, sender_pid} ->
        send(sender_pid, state)
        loop(state)

      {:take_a_number, sender_pid} ->
        new_state = state + 1
        send(sender_pid, new_state)
        loop(new_state)

      :stop ->
        nil

      _ ->
        loop(state)
    end
  end
end
