defmodule Plot do
  @moduledoc """
  Plot struct used in the `CommunityGarden` module
  """
  @enforce_keys [:plot_id, :registered_to]
  defstruct [:plot_id, :registered_to]
end

defmodule CommunityGarden do
  @moduledoc """
  A simple registry application to manage the community garden registrations.
  """

  @doc """
  Receives an optional keyword list of options to pass forward to the agent process.
  The garden's initial state will be initialized to represent an empty collection of plots.
  Returns an :ok tuple with the garden's pid.
  """
  @spec start(keyword) :: {:ok, pid}
  def start(opts \\ []), do: Agent.start(fn -> {[], 1} end, opts)

  @doc """
  Receives the pid for the community garden.
  Returns a list of the stored plots that are registered.
  """
  @spec list_registrations(pid) :: [%Plot{}]
  def list_registrations(pid), do: Agent.get(pid, fn {plots, _next_plot_id} -> plots end)

  @doc """
  Receive the pid for the community garden and a name to register the plot.
  Returns the Plot struct with the plot's id and person registered to when it is successful.
  """
  @spec register(pid, String.t()) :: %Plot{}
  def register(pid, register_to) do
    plot_id = Agent.get(pid, fn {_plots, next_plot_id} -> next_plot_id end)
    new_plot = %Plot{plot_id: plot_id, registered_to: register_to}
    Agent.update(pid, fn {plots, next_plot_id} -> {plots ++ [new_plot], next_plot_id + 1} end)
    new_plot
  end

  @doc """
  Receives the pid and id of the plot to be released.
  Return `:ok` on success.
  When a plot is released, the id is not re-used, it is used as a unique identifier only.
  """
  @spec release(pid, non_neg_integer) :: :ok
  def release(pid, plot_id),
    do:
      Agent.update(pid, fn {plots, next_plot_id} ->
        {Enum.filter(plots, fn plot -> plot.plot_id != plot_id end), next_plot_id}
      end)

  @doc """
  Receives the pid and id of the plot to be checked.
  Returns the plot if it is registered, and `:not_found` if it is unregistered.
  """
  @spec get_registration(pid, non_neg_integer) :: %Plot{} | {:not_found, String.t()}
  def get_registration(pid, plot_id),
    do:
      pid
      |> list_registrations()
      |> Enum.find({:not_found, "plot is unregistered"}, fn plot -> plot.plot_id == plot_id end)
end
