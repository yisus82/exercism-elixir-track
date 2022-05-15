defmodule Newsletter do
  @moduledoc """
  Functions to handle a newsletter
  """

  @doc """
  Takes a file path.
  The file is a text file that contains email addresses separated by newlines.
  Returns a list of the email addresses from the file.
  """
  @spec read_emails(Path.t()) :: [String.t()]
  def read_emails(path),
    do: File.read!(path) |> String.split("\n", trim: true)

  @doc """
  Takes a file path, opens the file for writing,
  and returns the PID of the process that handles the file.
  """
  @spec open_log(Path.t()) :: pid
  def open_log(path), do: File.open!(path, [:write])

  @doc """
  Takes a PID of the process that handles the file, and a string with the email address.
  It writes the email address to the file, followed by a newline.
  """
  @spec log_sent_email(pid, String.t()) :: :ok
  def log_sent_email(pid, email), do: IO.puts(pid, email)

  @doc """
  Takes a PID of the process that handles the file and closes the file.
  """
  @spec close_log(pid) :: :ok
  def close_log(pid), do: File.close(pid)

  @doc """
  Takes a path of the file with email addresses, a path of a log file,
  and an anonymous function that sends an email to a given email address.
  It reads all the email addresses from the given file and attempt to send an email to every one of them.
  If the anonymous function that sends the email returns `:ok`,
  writes the email address to the log file, followed by a new line.
  Afterwards, closes the log file.
  """
  @spec send_newsletter(Path.t(), Path.t(), (String.t() -> :ok)) :: :ok
  def send_newsletter(emails_path, log_path, send_fun) do
    log_pid = open_log(log_path)

    read_emails(emails_path)
    |> Enum.each(fn email ->
      if send_fun.(email) == :ok, do: log_sent_email(log_pid, email)
    end)

    close_log(log_pid)
  end
end
