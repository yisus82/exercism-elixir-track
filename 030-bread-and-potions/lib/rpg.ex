defmodule RPG do
  @moduledoc """
  You're developing your own role-playing video game.
  In your game, there are characters and items.
  One of the many actions that you can do with an item is to make a character eat it.

  Not all items are edible, and not all edible items have the same effects on the character.
  Some items, when eaten, turn into a different item (e.g. if you eat an apple, you are left
  with an apple core).

  To allow for all that flexibility, you decided to create an Edible protocol that some of
  the items can implement.
  """

  defmodule Character do
    defstruct health: 100, mana: 0
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  defprotocol Edible do
    @doc """
    Accepts an item and a character and returns a by-product and a character.
    """
    @spec eat(t, %Character{}) :: {any, %Character{}}
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    @spec eat(%RPG.LoafOfBread{}, %Character{}) ::
            {nil, %Character{}}
    def eat(_item, character), do: {nil, %{character | health: character.health + 5}}
  end

  defimpl Edible, for: ManaPotion do
    @spec eat(%RPG.ManaPotion{}, %Character{}) ::
            {%RPG.EmptyBottle{}, %Character{}}
    def eat(item, character),
      do: {%EmptyBottle{}, %{character | mana: character.mana + item.strength}}
  end

  defimpl Edible, for: Poison do
    @spec eat(%RPG.Poison{}, %Character{}) ::
            {%RPG.EmptyBottle{}, %Character{}}
    def eat(_item, character),
      do: {%EmptyBottle{}, %{character | health: 0}}
  end
end
