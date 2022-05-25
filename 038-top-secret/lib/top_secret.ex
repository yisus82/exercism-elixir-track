defmodule TopSecret do
  @moduledoc """
  You're part of a task force fighting against corporate espionage.
  You have a secret informer at Shady Company X, which you suspect of stealing secrets from its competitors.

  Your informer, Agent Ex, is an Elixir developer. She is encoding secret messages in her code.

  To decode her secret messages:
    * Take all functions (public and private) in the order they're defined in.
    * For each function, take the first `n` characters from its name, where `n` is the function's arity.
  """

  @doc """
  Takes a string with Elixir code and return its AST.
  """
  @spec to_ast(String.t()) :: Macro.t()
  def to_ast(string), do: Code.string_to_quoted!(string)

  @doc """
  Takes an AST node and an accumulator for the secret message (a list).
  Returns a tuple with the AST node unchanged as the first element,
  and the accumulator as the second element.

  If the operation of the AST node is defining a function (`def` or `defp`),
  prepends the first `n` characters from the funtion name, where `n` is the arity,
  to the accumulator.
  If the operation is something else, returns the accumulator unchanged.
  """
  @spec decode_secret_message_part(Macro.t(), list) :: {Macro.t(), list}
  def decode_secret_message_part({operator, _, def_arguments} = ast, acc)
      when operator in [:def, :defp] do
    {function_name, arity} = get_function_name_and_arity(def_arguments)

    {ast, [String.slice(function_name, 0, arity) | acc]}
  end

  def decode_secret_message_part(ast, acc), do: {ast, acc}

  defp get_function_name_and_arity(def_arguments) do
    case def_arguments do
      [{:when, _, arguments} | _] ->
        get_function_name_and_arity(arguments)

      [{function_name, _, arguments} | _] when is_list(arguments) ->
        {to_string(function_name), length(arguments)}

      [{function_name, _, arguments} | _] when is_atom(arguments) ->
        {to_string(function_name), 0}
    end
  end

  @doc """
  Takes a string with Elixir code and returns the secret message as a string decoded
  from all function definitions found in the code.
  """
  @spec decode_secret_message(String.t()) :: String.t()
  def decode_secret_message(string) do
    string
    |> to_ast()
    |> Macro.prewalk([], &decode_secret_message_part/2)
    |> elem(1)
    |> Enum.reverse()
    |> Enum.join()
  end
end
