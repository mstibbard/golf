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

  def get_scores_by_game_id!(game_id) do
    Score
    |> Score.by_game_id(game_id)
    |> Repo.all()
  end

  def get_scores_by_player_id!(player_id) do
    Score
    |> Score.by_player_id(player_id)
    |> Repo.all()
  end

  def get_score!(id), do: Repo.get!(Score, id)

  def create_score(attrs \\ %{}) do
    %Score{}
    |> Score.changeset(attrs)
    |> put_handicap
    |> put_handicap_change("create")
    |> put_new_handicap()
    |> Repo.insert()
  end

  def update_score(%Score{} = score, attrs) do
    score
    |> Score.changeset(attrs)
    |> put_handicap_change("update")
    |> put_new_handicap()
    |> Repo.update()
  end

  def delete_score(%Score{} = score) do
    Players.get_player!(score.player_id)
    |> update_handicap(D.minus(score.handicap_change))

    Repo.delete(score)
  end

  def delete_many_scores([]), do: []

  def delete_many_scores([hd | rest]) do
    get_score!(hd.id)
    |> delete_score()

    delete_many_scores(rest)
  end

  def change_score(%Score{} = score), do: Score.changeset(score, %{})

  def sum_player_scores_in_range!(player_id, min, max) do
    Score
    |> Score.within_date_range(player_id, min, max)
    |> Repo.all()
  end

  def get_stableford_top_scores(player_id, min, max) do
    Score
    |> Score.stableford_within_date_range(player_id, min, max)
    |> Repo.all()
    |> Enum.reverse()
    |> Enum.slice(1..3)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  defp put_handicap(changeset) do
    player = Players.get_player!(changeset.changes.player_id)
    Ecto.Changeset.put_change(changeset, :handicap, player.handicap)
  end

  defp put_handicap_change(changeset, action) do
    %{player: player, game: game} = get_player_and_game(changeset)

    cond do
      Map.has_key?(changeset.changes, :score) ->
        change =
          Calculator.calculate_change(
            changeset.changes.score,
            game.type,
            player.handicap
          )

        cond do
          action == "create" ->
            update_handicap(player, change)

            Ecto.Changeset.put_change(changeset, :handicap_change, change)

          action == "update" ->
            update_handicap(
              player,
              D.sub(change, changeset.data.handicap_change)
            )

            Ecto.Changeset.put_change(changeset, :handicap_change, change)
        end

      Map.has_key?(changeset.changes, :handicap_change) ->
        update_handicap(
          player,
          D.sub(changeset.changes.handicap_change, changeset.data.handicap_change)
        )

        changeset

      true ->
        changeset
    end
  end

  defp put_new_handicap(changeset) do
    has_change? = Map.has_key?(changeset.changes, :handicap_change)
    cond do
      has_change? ->
        check = Map.has_key?(changeset.changes, :handicap)

        cond do
          check == true ->
            Ecto.Changeset.put_change(
              changeset,
              :new_handicap,
              D.add(changeset.changes.handicap, changeset.changes.handicap_change)
            )

          check == false ->
            Ecto.Changeset.put_change(
              changeset,
              :new_handicap,
              D.add(changeset.data.handicap, changeset.changes.handicap_change)
            )
        end

      true ->
        changeset
    end
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
