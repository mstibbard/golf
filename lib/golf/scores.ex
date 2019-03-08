defmodule Golf.Scores do
  @moduledoc """
  The Scores context.
  """

  import Ecto.Query, warn: false
  alias Golf.Repo

  alias Decimal, as: D
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
    |> put_handicap_change("create")
    |> Repo.insert()
  end

  def update_score(%Score{} = score, attrs) do
    score
    |> Score.changeset(attrs)
    |> put_handicap_change("update")
    |> Repo.update()
  end

  def delete_score(%Score{} = score) do
    player = Players.get_player!(score.player_id)
    update_handicap(player, D.minus(score.handicap_change))
    Repo.delete(score)
  end

  def change_score(%Score{} = score), do: Score.changeset(score, %{})

  defp put_handicap_change(changeset, action) do
    %{player: player, game: game} = get_player_and_game(changeset)

    change =
      Calculator.calculate_change(
        changeset.changes.score,
        game.type,
        player.handicap
      )

    cond do
      action == "create" ->
        update_handicap(player, change)

      action == "update" ->
        update_handicap(
          player,
          D.sub(change, changeset.data.handicap_change)
        )
    end

    Ecto.Changeset.put_change(changeset, :handicap_change, change)
  end

  defp get_player_and_game(changeset) do
    check = Map.has_key?(changeset.changes, :player_id)

    cond do
      check == true ->
        player = Players.get_player!(changeset.changes.player_id)
        game = Games.get_game!(changeset.changes.game_id)

        %{player: player, game: game}

      check == false ->
        player = Players.get_player!(changeset.data.player_id)
        game = Games.get_game!(changeset.data.game_id)

        %{player: player, game: game}
    end
  end

  defp update_handicap(player, change) do
    attrs = %{handicap: D.add(player.handicap, change)}
    Players.update_player(player, attrs)
  end
end
