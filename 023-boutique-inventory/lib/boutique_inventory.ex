defmodule BoutiqueInventory do
  @moduledoc """
  Functions to take stock of a boutique inventory.
  A single item in the inventory is represented by a map,
  and the whole inventory is a list of such maps.
  """

  @typedoc """
  Inventory item
  """
  @type inventory_item :: %{
          name: String.t(),
          price: number,
          quantity_by_size: %{
            s: non_neg_integer,
            m: non_neg_integer,
            l: non_neg_integer,
            xl: non_neg_integer
          }
        }

  @typedoc """
  Full inventory
  """
  @type inventory_items :: [inventory_item]

  @doc """
  Takes the inventory and returns it sorted by item price, ascending.
  """
  @spec sort_by_price(inventory_items) :: inventory_items
  def sort_by_price(inventory),
    do: Enum.sort_by(inventory, fn item -> item[:price] end, :asc)

  @doc """
  Takes the inventory and returns a list of items that do not have prices.
  """
  @spec with_missing_price(inventory_items) :: inventory_items
  def with_missing_price(inventory),
    do: Enum.filter(inventory, fn item -> item[:price] == nil end)

  @doc """
  Takes the inventory, the old word we want to remove from the items' names,
  and a new word we want to use instead.
  Returns a list of items with updated names.
  """
  @spec update_names(inventory_items, String.t(), String.t()) :: inventory_items
  def update_names(inventory, old_word, new_word),
    do:
      Enum.map(inventory, fn item ->
        Map.replace(item, :name, String.replace(item[:name], old_word, new_word))
      end)

  @doc """
  Take a single inventory item and a number, and returns that item with the quantity
  for each size increased by that number.
  """
  @spec increase_quantity(inventory_item, non_neg_integer) :: inventory_item
  def increase_quantity(item, count),
    do: %{
      item
      | quantity_by_size:
          Map.new(item[:quantity_by_size], fn {key, value} -> {key, value + count} end)
    }

  @doc """
  Takes a single inventory item and returns how many pieces are in total, in any size.
  """
  @spec total_quantity(inventory_item) :: non_neg_integer
  def total_quantity(item),
    do: Enum.reduce(item[:quantity_by_size], 0, fn {_size, quantity}, acc -> acc + quantity end)
end
