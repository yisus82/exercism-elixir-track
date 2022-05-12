defmodule NameBadge do
  @moduledoc """
  Code to print name badges for factory employees.
  Employees have an ID, name, and department name.
  Employee badge labels are formatted as `[id] - name - DEPARTMENT`.
  """

  @doc """
  Takes an id, name, and a department.
  Returns the badge label, with the department name in uppercase.
  When the `id` is missing, returns a badge without it.
  When the `department` is missing, the badge belongs to the company owner.
  """
  @spec print(non_neg_integer | nil, String.t(), String.t() | nil) :: String.t()
  def print(id, name, department) do
    if(id == nil, do: "", else: "[#{id}] - ")
    |> Kernel.<>("#{name} - ")
    |> Kernel.<>(if department == nil, do: "OWNER", else: String.upcase(department))
  end
end
