defmodule TakeANumberDeluxe do
  @moduledoc """
  The basic Take-A-Number machine was selling really well, but some users were complaining
  about its lack of advanced features compared to other models available on the market.

  The manufacturer listened to user feedback and decided to release a deluxe model with more features,
  and you once again were tasked with writing the software for this machine.

  The new features added to the deluxe model include:
    * Keeping track of currently queued numbers.
    * Setting the minimum and maximum number. This will allow using multiple deluxe Take-A-Number machines
      for queueing customers to different departments at the same facility, and to tell apart the
      departments by the number range.
    * Allowing certain numbers to skip the queue to provide priority service to pregnant women and the elderly.
    * Auto shutdown to prevent accidentally leaving the machine on for the whole weekend and wasting energy.

  The business logic of the machine was already implemented by your colleague and can be found in the
  module `TakeANumberDeluxe.State`. Now your task is to wrap it in a `GenServer`.
  """

  use GenServer

  # Client API

  @doc """
  The argument passed to `start_link/1` is a keyword list.
  It contains the keys `:min_number` and `:max_number`.
  The values under those keys need to be passed to the function `TakeANumberDeluxe.State.new/2`.

  If `TakeANumberDeluxe.State.new/2` returns an `{:ok, state}` tuple, the machine should start,
  using the returned state as its state.
  If it returns an `{:error, error}` tuple instead, the machine should stop, giving the returned error
  as the reason for stopping.
  """
  @spec start_link(keyword) :: {:ok, pid} | {:error, atom}
  def start_link(init_arg), do: GenServer.start_link(__MODULE__, init_arg)

  @doc """
  The machine should reply to the caller with its current state.
  """
  @spec report_state(pid) :: TakeANumberDeluxe.State.t()
  def report_state(machine), do: GenServer.call(machine, :report_state)

  @doc """
  It calls the `TakeANumberDeluxe.State.queue_new_number/1` function with the current state of the machine.

  If `TakeANumberDeluxe.State.queue_new_number/1` returns an `{:ok, new_number, new_state}` tuple,
  the machine should reply to the caller with the new number and set the new state as its state.
  If it returns a `{:error, error}` tuple instead, the machine should reply to the caller with
  the error and not change its state.
  """
  @spec queue_new_number(pid) :: {:ok, integer} | {:error, atom}
  def queue_new_number(machine), do: GenServer.call(machine, :queue_new_number)

  @doc """
  It calls the `TakeANumberDeluxe.State.serve_next_queued_number/2` function with the current state
  of the machine and its second optional argument, `priority_number`.

  If `TakeANumberDeluxe.State.serve_next_queued_number/2` returns an `{:ok, next_number, new_state}` tuple,
  the machine should reply to the caller with the next number and set the new state as its state.
  If it returns a `{:error, error}` tuple instead, the machine should reply to the caller with the error
  and not change its state.
  """
  @spec serve_next_queued_number(pid, integer | nil) :: {:ok, integer} | {:error, atom}
  def serve_next_queued_number(machine, priority_number \\ nil),
    do: GenServer.call(machine, {:serve_next_queued_number, priority_number})

  @doc """
  It calls the `TakeANumberDeluxe.State.new/2` function to create a new state using the current state's
  `min_number` and `max_number`.
  The machine should set the new state as its state.
  It does not reply to the caller.
  """
  @spec reset_state(pid) :: :ok
  def reset_state(machine), do: GenServer.cast(machine, :reset_state)

  # Server callbacks

  @impl GenServer
  @spec init(keyword) :: {:ok, TakeANumberDeluxe.State.t()} | {:stop, atom}
  def init(init_arg) do
    case TakeANumberDeluxe.State.new(
           init_arg[:min_number],
           init_arg[:max_number],
           Keyword.get(init_arg, :auto_shutdown_timeout, :infinity)
         ) do
      {:ok, state} -> {:ok, state, state.auto_shutdown_timeout}
      {:error, reason} -> {:stop, reason}
    end
  end

  @impl GenServer
  def handle_call(:report_state, _from, state),
    do: {:reply, state, state, state.auto_shutdown_timeout}

  @impl GenServer
  def handle_call(:queue_new_number, _from, state) do
    case TakeANumberDeluxe.State.queue_new_number(state) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_call({:serve_next_queued_number, priority_number}, _from, state) do
    case TakeANumberDeluxe.State.serve_next_queued_number(state, priority_number) do
      {:ok, new_number, new_state} ->
        {:reply, {:ok, new_number}, new_state, new_state.auto_shutdown_timeout}

      {:error, reason} ->
        {:reply, {:error, reason}, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_cast(:reset_state, state) do
    case TakeANumberDeluxe.State.new(
           state.min_number,
           state.max_number,
           state.auto_shutdown_timeout
         ) do
      {:ok, new_state} -> {:noreply, new_state, new_state.auto_shutdown_timeout}
      _ -> {:noreply, state, state.auto_shutdown_timeout}
    end
  end

  @impl GenServer
  def handle_info(:timeout, state), do: {:stop, :normal, state}

  @impl GenServer
  def handle_info(_, state), do: {:noreply, state, state.auto_shutdown_timeout}
end
