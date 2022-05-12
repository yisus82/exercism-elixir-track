defmodule Username do
  @moduledoc """
  Functions to create sanitized aliases for all email accounts.
  """

  @doc """
  Takes an username as a charlist and returns a sanitized charlist.
  """
  @spec sanitize(charlist) :: charlist
  def sanitize(username) do
    case username do
      # Empty charlist
      [] ->
        ''

      # Underscore
      [?_ | rest] ->
        [?_ | sanitize(rest)]

      # German character ä
      [?ä | rest] ->
        'ae' ++ sanitize(rest)

      # German character ö
      [?ö | rest] ->
        'oe' ++ sanitize(rest)

      # German character ü
      [?ü | rest] ->
        'ue' ++ sanitize(rest)

      # German character ß
      [?ß | rest] ->
        'ss' ++ sanitize(rest)

      # Lowercase letters
      [first_letter | rest] when first_letter >= ?a and first_letter <= ?z ->
        [first_letter | sanitize(rest)]

      # Other characters
      [_ | rest] ->
        sanitize(rest)
    end
  end
end
