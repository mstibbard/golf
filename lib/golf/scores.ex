defmodule Golf.Scores do
  @moduledoc """
  The Scores context.
  """

  import Ecto.Query, warn: false
  alias Golf.Repo

  alias Golf.Calculator
  alias Golf.Games
  alias Golf.Games.Score
  alias Golf.Players

  def list_scores do
    Score
    |> Repo.all()
  end

  def get_score!(id), do: Repo.get!(Score, id)

  def create_score(attrs \\ %{}) do
    %Score{}
    |> Score.changeset(attrs)
    |> put_handicap_change()
    |> Repo.insert()
  end

  def update_score(%Score{} = score, attrs) do
    score
    |> Score.changeset(attrs)
    |> Repo.update()
  end

  def delete_score(%Score{} = score), do: Repo.delete(score)

  def change_score(%Score{} = score), do: Score.changeset(score, %{})

  defp put_handicap_change(changeset) do
    player = Players.get_player!(changeset.changes.player_id)
    game = Games.get_game!(changeset.changes.game_id)

    change =
      Calculator.calculate_change(
        changeset.changes.score,
        game.type,
        player.handicap
      )

    Ecto.Changeset.put_change(changeset, :handicap_change, change)
  end
end
