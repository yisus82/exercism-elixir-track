defmodule FileSniffer do
  @moduledoc """
  Functions to verify that an upload matches its media type.
  The first few bytes of a file are generally unique to that file type, giving it a sort of signature.

  | File type | Common extension | Media type                   | binary 'signature'                               |
  | --------- | ---------------- | ---------------------------- | ------------------------------------------------ |
  | ELF       | `"exe"`          | `"application/octet-stream"` | `0x7F, 0x45, 0x4C, 0x46`                         |
  | BMP       | `"bmp"`          | `"image/bmp"`                | `0x42, 0x4D`                                     |
  | PNG       | `"png"`          | `"image/png"`                | `0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A` |
  | JPG       | `"jpg"`          | `"image/jpg"`                | `0xFF, 0xD8, 0xFF`                               |
  | GIF       | `"gif"`          | `"image/gif"`                | `0x47, 0x49, 0x46`                               |
  """

  @file_types %{
    ELF: %{
      extension: "exe",
      media_type: "application/octet-stream",
      signature: <<0x7F, 0x45, 0x4C, 0x46>>
    },
    BMP: %{
      extension: "bmp",
      media_type: "image/bmp",
      signature: <<0x42, 0x4D>>
    },
    PNG: %{
      extension: "png",
      media_type: "image/png",
      signature: <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>
    },
    JPG: %{
      extension: "jpg",
      media_type: "image/jpg",
      signature: <<0xFF, 0xD8, 0xFF>>
    },
    GIF: %{
      extension: "gif",
      media_type: "image/gif",
      signature: <<0x47, 0x49, 0x46>>
    }
  }

  @doc """
  Takes a file extension and returns the media type.
  """
  @spec type_from_extension(String.t()) :: String.t()
  def type_from_extension(extension),
    do:
      @file_types
      |> Map.values()
      |> Enum.find(%{}, fn element -> element.extension == extension end)
      |> Map.get(:media_type)

  @doc """
  Takes a binary file and returns the media type.
  """
  @spec type_from_binary(binary) :: String.t()
  def type_from_binary(file_binary),
    do:
      @file_types
      |> Map.values()
      |> Enum.find(%{}, fn element -> String.starts_with?(file_binary, element.signature) end)
      |> Map.get(:media_type)

  @doc """
  Takes a binary file and an extension and returns an `:ok` or `:error` tuple.
  """
  @spec verify(binary, String.t()) :: {:ok | :error, String.t()}
  def verify(file_binary, extension) do
    binary_type = type_from_binary(file_binary)
    extension_type = type_from_extension(extension)

    if binary_type == extension_type,
      do: {:ok, binary_type},
      else: {:error, "Warning, file format and file extension do not match."}
  end
end
