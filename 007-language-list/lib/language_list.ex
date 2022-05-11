defmodule LanguageList do
  @moduledoc """
  Some functions to manipulate a list of programming languages.
  """

  @doc """
  Takes no arguments and returns an empty list.
  """
  @spec new :: []
  def new(), do: []

  @doc """
  Takes 2 arguments: a language list and a string literal of a language.
  Returns the resulting list with the new language prepended to the given list.
  """
  @spec add([String.t()], String.t()) :: [String.t()]
  def add(list, language), do: [language | list]

  @doc """
  Takes 1 argument: a language list.
  Returns the list without the first language, assuming `list` always has at least one item.
  """
  @spec remove([String.t()]) :: [String.t()]
  def remove([_head | tail]), do: tail

  @doc """
  Takes 1 argument: a language list.
  Returns the first language, assuming `list` always has at least one item.
  """
  @spec first([String.t()]) :: String.t()
  def first([head | _tail]), do: head

  @doc """
  Takes 1 argument: a language list.
  Returns the number of languages in `list`.
  """
  @spec count([String.t()]) :: non_neg_integer
  def count(list), do: length(list)

  @doc """
  Takes 1 argument: a language list.
  Returns `true` if `Elixir` is one of the languages in the list.
  """
  @spec functional_list?([String.t()]) :: boolean
  def functional_list?(list), do: "Elixir" in list
end
