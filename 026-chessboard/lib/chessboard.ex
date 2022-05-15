defmodule Chessboard do
  @moduledoc """
  Functions to generate a chess board.
  Each square of the chessboard is identified by a letter-number pair.
  The vertical columns of squares, called files, are labeled A through H.
  The horizontal rows of squares, called ranks, are numbered 1 to 8.
  """

  @doc """
  Returns a range of integers, from 1 to 8.
  """
  @spec rank_range :: Range.t(1, 8)
  def rank_range, do: 1..8

  @doc """
  Returns a range of integers, from the code point of the uppercase letter A,
  to the code point of the uppercase letter H.
  """
  @spec file_range :: Range.t(?A, ?H)
  def file_range, do: ?A..?H

  @doc """
  Returns a list of integers, from 1 to 8,
  generated from the range returned by the `rank_range/0` function.
  """
  @spec ranks :: [Range.t(1, 8)]
  def ranks, do: rank_range() |> Enum.to_list()

  @doc """
  Returns a list of letters (strings), from "A" to "H",
  generated from the range returned by the `file_range/0` function.
  """
  @spec files :: [String.t()]
  def files,
    do: file_range() |> Enum.map(fn file -> <<file>> end)
end
