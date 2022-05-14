defmodule DNA do
  @moduledoc """
  A module to encode and decode DNA data to benchmark savings in data storage costs.

  Table used to convert the DNA data to a binary representation:
  | Nucleic Acid | Code   |
  | ------------ | ------ |
  | a space      | `0000` |
  | A            | `0001` |
  | C            | `0010` |
  | G            | `0100` |
  | T            | `1000` |
  """

  @doc """
  Accepts the code point for the nucleic acid and returns the integer value of the encoded code.
  """
  @spec encode_nucleotide(32 | 65 | 67 | 71 | 84) :: 0 | 1 | 2 | 4 | 8
  def encode_nucleotide(code_point) do
    case code_point do
      ?A -> 0b0001
      ?C -> 0b0010
      ?G -> 0b0100
      ?T -> 0b1000
      ?\s -> 0b0000
    end
  end

  @doc """
  Accepts the integer value of the encoded code and returns the code point for the nucleic acid.
  """
  @spec decode_nucleotide(0 | 1 | 2 | 4 | 8) :: 32 | 65 | 67 | 71 | 84
  def decode_nucleotide(encoded_code) do
    case encoded_code do
      0b0001 -> ?A
      0b0010 -> ?C
      0b0100 -> ?G
      0b1000 -> ?T
      0b0000 -> ?\s
    end
  end

  @doc """
  Accepts a charlist representing nucleic acids and gaps and returns a bitstring of the encoded data.
  """
  @spec encode([32 | 65 | 67 | 71 | 84]) :: bitstring
  def encode(dna), do: do_encode(dna, <<>>)

  defp do_encode([], encoding), do: encoding

  defp do_encode([head | tail], encoding),
    do: do_encode(tail, <<encoding::bitstring, encode_nucleotide(head)::4>>)

  @doc """
  Accepts a bitstring representing nucleic acids and gaps and returns the decoded data as a charlist.
  """
  @spec decode(bitstring) :: [32 | 65 | 67 | 71 | 84]
  def decode(dna), do: do_decode(dna, '')

  defp do_decode(<<0::0>>, decoding), do: decoding

  defp do_decode(<<value::4, rest::bitstring>>, decoding),
    do: do_decode(rest, decoding ++ [decode_nucleotide(value)])
end
