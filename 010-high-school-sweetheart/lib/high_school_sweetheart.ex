defmodule HighSchoolSweetheart do
  @moduledoc """
  Functions to help high school sweethearts profess their love
  on social media by generating an ASCII heart with their initials
  """

  @doc """
  Takes a name and returns its first letter.
  It cleans up any unnecessary whitespace from the name.
  """
  @spec first_letter(String.t()) :: String.t()
  def first_letter(name), do: name |> String.trim() |> String.first()

  @doc """
  Takes a name and return its first letter, uppercase, followed by a dot.
  """
  @spec initial(String.t()) :: String.t()
  def initial(name),
    do:
      name
      |> first_letter
      |> String.upcase()
      |> Kernel.<>(".")

  @doc """
  Take a full name, consisting of a first name and a last name separated by a space,
  and returns the initials.
  """
  @spec initials(String.t()) :: String.t()
  def initials(full_name),
    do: full_name |> String.split(" ") |> Enum.map(&initial/1) |> Enum.join(" ")

  @doc """
  Takes two full names and return their initials inside a heart.
  """
  @spec pair(String.t(), String.t()) :: String.t()
  def pair(full_name1, full_name2) do
    i1 = initials(full_name1)
    i2 = initials(full_name2)

    """
         ******       ******
       **      **   **      **
     **         ** **         **
    **            *            **
    **                         **
    **     #{i1}  +  #{i2}     **
     **                       **
       **                   **
         **               **
           **           **
             **       **
               **   **
                 ***
                  *
    """
  end
end
