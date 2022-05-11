defmodule HighScore do
  @moduledoc """
  Functions to keep track of the high scores for the most popular game in the local arcade hall.
  """

  @initial_score 0

  @typedoc """
  Map to track the scores
  """
  @type scores_map :: %{name: non_neg_integer}

  @doc """
  Doesn't take any arguments and returns a new, empty map of high scores.
  """
  @spec new :: %{}
  def new(), do: %{}

  @doc """
  Adds a player to the map of scores.
  Takes 3 arguments: the map of scores, the name of a player, and the score.
  The score is optional, with a default value of 0.
  """
  @spec add_player(scores_map, String.t(), non_neg_integer) :: scores_map
  def add_player(scores, name, score \\ @initial_score), do: Map.put(scores, name, score)

  @doc """
  Removes a player from the map of scores.
  Takes 2 arguments: the map of scores, and the name of a player.
  """
  @spec remove_player(scores_map, String.t()) :: scores_map
  def remove_player(scores, name), do: Map.delete(scores, name)

  @doc """
  Resets a player's score in the map of scores.
  Takes 2 arguments: the map of scores, and the name of a player.
  """
  @spec reset_score(scores_map, Strign.t()) :: scores_map
  def reset_score(scores, name), do: Map.put(scores, name, @initial_score)

  @doc """
  Updates a player's score to the map of scores.
  Takes 3 arguments: the map of scores, the name of a player,
  and the score to add to the stored high score.
  """
  @spec update_score(scores_map, String.t(), non_neg_integer) :: scores_map
  def update_score(scores, name, score),
    do: Map.update(scores, name, score, fn existing_value -> existing_value + score end)

  @doc """
  Takes the map of scores and returns the players' names.
  """
  @spec get_players(scores_map) :: [String.t()]
  def get_players(scores), do: Map.keys(scores)
end
