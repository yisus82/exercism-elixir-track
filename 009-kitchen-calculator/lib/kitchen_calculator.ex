defmodule KitchenCalculator do
  @moduledoc """
  Functions to convert common US baking measurements to milliliters (mL) using this chart:
  | Unit to convert | Volume | In milliliters (mL) |
  | --------------- | ------ | ------------------- |
  | mL              | 1      | 1                   |
  | US cup          | 1      | 240                 |
  | US fluid ounce  | 1      | 30                  |
  | US teaspoon     | 1      | 5                   |
  | US tablespoon   | 1      | 15                  |
  """

  @typedoc """
  Volume units
  """
  @type unit :: :cup | :fluid_ounce | :teaspoon | :tablespoon | :milliliter

  @doc """
  Given a volume-pair tuple, returns just the numeric component.
  """
  @spec get_volume({unit, number}) :: number
  def get_volume(volume_pair) do
    {_, volume} = volume_pair
    volume
  end

  @doc """
  Given a volume-pair tuple, converts the volume to milliliters using the conversion chart.
  """
  @spec to_milliliter({unit, number}) :: {:milliliter, float}
  def to_milliliter({:milliliter, volume}), do: {:milliliter, volume * 1.0}

  def to_milliliter({:cup, volume}), do: {:milliliter, volume * 240.0}

  def to_milliliter({:fluid_ounce, volume}), do: {:milliliter, volume * 30.0}

  def to_milliliter({:teaspoon, volume}), do: {:milliliter, volume * 5.0}

  def to_milliliter({:tablespoon, volume}), do: {:milliliter, volume * 15.0}

  @doc """
  Given a volume-pair tuple in milliliters and the desired unit, converts the volume to the desired unit using the conversion chart.
  """
  @spec from_milliliter(
          {unit, number},
          unit
        ) ::
          {unit, float}
  def from_milliliter(volume_pair, :milliliter), do: {:milliliter, get_volume(volume_pair) / 1.0}

  def from_milliliter(volume_pair, :cup), do: {:cup, get_volume(volume_pair) / 240.0}

  def from_milliliter(volume_pair, :fluid_ounce),
    do: {:fluid_ounce, get_volume(volume_pair) / 30.0}

  def from_milliliter(volume_pair, :teaspoon), do: {:teaspoon, get_volume(volume_pair) / 5.0}

  def from_milliliter(volume_pair, :tablespoon), do: {:tablespoon, get_volume(volume_pair) / 15.0}

  @doc """
  Given a volume-pair tuple and the desired unit, converts the given volume to the desired unit.
  """
  @spec convert(
          {unit, number},
          unit
        ) ::
          {unit, float}
  def convert(volume_pair, unit),
    do:
      volume_pair
      |> to_milliliter
      |> from_milliliter(unit)
end
