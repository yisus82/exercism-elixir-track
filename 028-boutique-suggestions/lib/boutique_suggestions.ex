defmodule BoutiqueSuggestions do
  @moduledoc """
  Functions to use a list comprehension to generate outfit combinations,
  then filter them by some criteria.

  Clothing items are stored as a map:

  ```elixir
  %{
    item_name: "Descriptive Name",
    price: 99.00,
    base_color: "red",
    color: "Deep Red",
    quantity: 4
  }
  ```
  """

  @typedoc """
  Clothing item
  """
  @type clothing_item :: %{
          item_name: String.t(),
          price: number,
          base_color: String.t(),
          color: String.t(),
          quantity: non_neg_integer
        }

  @doc """
  Take a list of tops, a list of bottoms, and keyword list of options.
  Return the cartesian product of the lists, filtered by the filter options.
  """
  @spec get_combinations([clothing_item], [clothing_item], keyword) :: [
          {clothing_item, clothing_item}
        ]
  def get_combinations(tops, bottoms, options \\ []) do
    maximum_price = Keyword.get(options, :maximum_price, 100.00)

    for(
      top <- tops,
      bottom <- bottoms,
      top.base_color != bottom.base_color and
        top.price + bottom.price <= maximum_price
    ) do
      {top, bottom}
    end
  end
end
