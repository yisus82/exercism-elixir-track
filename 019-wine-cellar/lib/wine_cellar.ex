defmodule WineCellar do
  @moduledoc """
  An app that will let guests filter wines by their preferences.
  """

  @typedoc """
  Wine colors
  """
  @type wine_color :: :white | :red | :rose

  @doc """
  Takes no arguments and returns a keyword list with wine colors as keys and explanations as values.
  """
  @spec explain_colors :: [{wine_color, String.t()}]
  def explain_colors,
    do: [
      white: "Fermented without skin contact.",
      red: "Fermented with skin contact using dark-colored grapes.",
      rose: "Fermented with some skin contact, but not enough to qualify as a red wine."
    ]

  @doc """
  Takes a keyword list of wines, a color atom and a keyword list of options, with a default value of [].
  Returns a list of wines of a given color with the specified options.
  """
  @spec filter([{wine_color, String.t()}], wine_color, [{atom, any}]) :: [
          {String.t(), non_neg_integer, String.t()}
        ]
  def filter(cellar, color, opts \\ []) do
    cellar
    |> Keyword.get_values(color)
    |> then(&put_elem({[], Keyword.get(opts, :year), Keyword.get(opts, :country)}, 0, &1))
    |> case do
      {wines, nil, nil} -> wines
      {wines, year, nil} -> wines |> filter_by_year(year)
      {wines, nil, country} -> wines |> filter_by_country(country)
      {wines, year, country} -> wines |> filter_by_year(year) |> filter_by_country(country)
    end
  end

  # The functions below do not need to be modified.

  defp filter_by_year(wines, year)
  defp filter_by_year([], _year), do: []

  defp filter_by_year([{_, year, _} = wine | tail], year) do
    [wine | filter_by_year(tail, year)]
  end

  defp filter_by_year([{_, _, _} | tail], year) do
    filter_by_year(tail, year)
  end

  defp filter_by_country(wines, country)
  defp filter_by_country([], _country), do: []

  defp filter_by_country([{_, _, country} = wine | tail], country) do
    [wine | filter_by_country(tail, country)]
  end

  defp filter_by_country([{_, _, _} | tail], country) do
    filter_by_country(tail, country)
  end
end
