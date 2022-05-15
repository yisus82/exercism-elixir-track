defmodule RemoteControlCar do
  @moduledoc """
  Functions to play with a remote controlled car.

  Cars start with full (100%) batteries.
  Each time you drive the car using the remote control,
  it covers 20 meters and drains one percent of the battery.
  The car's nickname is not known until it is created.

  The remote controlled car has a fancy LED display that shows two bits of information:
    * The total distance it has driven, displayed as: `"<METERS> meters"`.
    * The remaining battery charge, displayed as: `"Battery at <PERCENTAGE>%"`.

  If the battery is at 0%, you can't drive the car anymore
  and the battery display will show `"Battery empty"`.
  """

  @enforce_keys [:nickname]
  defstruct [:nickname, battery_percentage: 100, distance_driven_in_meters: 0]

  @typedoc """
  Remote controlled car struct
  """
  @type remote_controlled_car :: %RemoteControlCar{
          battery_percentage: non_neg_integer,
          distance_driven_in_meters: non_neg_integer,
          nickname: String.t()
        }

  @doc """
  Returns a brand-new remote controlled car struct with the provided `nickname`
  """
  @spec new(nickname :: String.t()) :: remote_controlled_car
  def new(nickname \\ "none"), do: %RemoteControlCar{nickname: nickname}

  @doc """
  Returns the distance as displayed on the LED display
  """
  @spec display_distance(remote_controlled_car) :: String.t()
  def display_distance(%RemoteControlCar{
        distance_driven_in_meters: distance
      }),
      do: "#{distance} meters"

  @doc """
  Returns the battery percentage as displayed on the LED display
  """
  @spec display_battery(remote_controlled_car) :: String.t()
  def display_battery(%RemoteControlCar{
        battery_percentage: 0
      }),
      do: "Battery empty"

  def display_battery(%RemoteControlCar{
        battery_percentage: percentage
      }),
      do: "Battery at #{percentage}%"

  @doc """
  Updates the number of meters driven by 20 meters and drains 1% of the battery, if there is battery left
  """
  @spec drive(remote_controlled_car) :: remote_controlled_car
  def drive(
        %RemoteControlCar{
          battery_percentage: 0
        } = remote_car
      ),
      do: remote_car

  def drive(
        %RemoteControlCar{
          battery_percentage: percentage,
          distance_driven_in_meters: distance
        } = remote_car
      ),
      do: %{
        remote_car
        | distance_driven_in_meters: distance + 20,
          battery_percentage: percentage - 1
      }
end
