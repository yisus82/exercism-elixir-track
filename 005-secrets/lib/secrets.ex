defmodule Secrets do
  @moduledoc """
  Functions for an encryption device that works by performing transformations on data.
  """

  @doc """
  Returns a function which takes one argument and adds it to the `secret`.
  """
  @spec secret_add(integer) :: (integer -> integer)
  def secret_add(secret), do: &Kernel.+(&1, secret)

  @doc """
  Returns a function which takes one argument and subtracts from it the `secret`.
  """
  @spec secret_subtract(integer) :: (integer -> integer)
  def secret_subtract(secret), do: &Kernel.-(&1, secret)

  @doc """
  Returns a function which takes one argument and multiplies it by the `secret`.
  """
  @spec secret_multiply(integer) :: (integer -> integer)
  def secret_multiply(secret), do: &Kernel.*(&1, secret)

  @doc """
  Returns a function which takes one argument and divides it by the `secret`.
  """
  @spec secret_divide(integer) :: (integer -> integer)
  def secret_divide(secret), do: &Kernel.div(&1, secret)

  @doc """
  Returns a function which takes one argument and performs a
  `bitwise and` operation on it and the `secret`.
  """
  @spec secret_and(integer) :: (integer -> integer)
  def secret_and(secret), do: &Bitwise.band(&1, secret)

  @doc """
  Returns a function which takes one argument and performs a
  `bitwise xor` operation on it and the `secret`.
  """
  @spec secret_xor(integer) :: (integer -> integer)
  def secret_xor(secret), do: &Bitwise.bxor(&1, secret)

  @doc """
  Returns a function which takes one argument and applies to it
  the two functions passed in to `secret_combine/2` in order.
  """
  @spec secret_combine((integer -> integer), (integer -> integer)) :: (integer -> integer)
  def secret_combine(secret_function1, secret_function2),
    do: &(&1 |> then(secret_function1) |> then(secret_function2))
end
