defmodule LogLevel do
  @moduledoc """
  Program for a system that consists of a few applications producing many logs.
  The program will aggregate those logs and give them labels according to their severity level.
  All applications in the system use the same log codes, but some of the legacy applications
  don't support all the codes.
  | Log code | Log label | Supported in legacy apps? |
  | -------- | --------- | ------------------------- |
  | 0        | trace     | no                        |
  | 1        | debug     | yes                       |
  | 2        | info      | yes                       |
  | 3        | warning   | yes                       |
  | 4        | error     | yes                       |
  | 5        | fatal     | no                        |
  | ?        | unknown   | -                         |
  """

  @doc """
  Takes an integer code and a boolean flag telling if the log comes from a legacy app.
  Returns the label of a log line as an atom.
  Unknown log codes and codes unsupported in a legacy app should return an `:unknown` label.
  """
  @spec to_label(integer, boolean) ::
          :debug | :error | :fatal | :info | :trace | :unknown | :warning
  def to_label(level, legacy?) do
    cond do
      level == 0 and not legacy? -> :trace
      level == 1 -> :debug
      level == 2 -> :info
      level == 3 -> :warning
      level == 4 -> :error
      level == 5 and not legacy? -> :fatal
      true -> :unknown
    end
  end

  @doc """
  Take an integer code and a boolean flag telling if the log comes from a legacy app.
  Return the name of the recipient as an atom, acording to these rules:
    * If the log label is error or fatal, send the alert to the ops team.
    * If a log with an unknown label from a legacy system is received, send the alert to the dev1 team.
    * Other unknown labels should be sent to the dev2 team.
    * All other log labels can be safely ignored.
  """
  @spec alert_recipient(integer, boolean) :: :dev1 | :dev2 | false | :ops
  def alert_recipient(level, legacy?) do
    label = to_label(level, legacy?)

    cond do
      label == :error or label == :fatal ->
        :ops

      label == :unknown and legacy? ->
        :dev1

      label == :unknown and not legacy? ->
        :dev2

      true ->
        false
    end
  end
end
