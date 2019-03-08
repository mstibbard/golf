defmodule Golf.ScoresTest do
  use Golf.DataCase

  alias Golf.Games.Score
  alias Golf.Players
  alias Golf.Scores
  alias Decimal, as: D

  describe "scores" do
    @valid_attrs %{score: 36, handicap_change: 0.0, player_id: 0, game_id: 0}
    @update_attrs %{score: 40, handicap_change: 0.0}
    @invalid_attrs %{score: -30, handicap_change: nil, player_id: nil, game_id: nil}

    setup do
      %{id: game_id} = game_fixture()
      %{id: player_id} = player_fixture()

      {:ok, %{game_id: game_id, player_id: player_id}}
    end

    test "list_scores/0 lists all scores" do
      score = score_fixture()
      assert Scores.list_scores() == [score]
    end

    test "get_score!/1 with valid id returns the score" do
      score = score_fixture()
      assert Scores.get_score!(score.id) == score
    end

    test "create_score/1 with valid data creates a score", prep do
      attrs =
        prep
        |> Enum.into(@valid_attrs)

      assert {:ok, %Score{} = score} = Scores.create_score(attrs)
      assert score.score == 36
      assert score.handicap_change == D.new("0.3")
    end

    test "create_score/1 with invalid data returns error changeset", prep do
      attrs =
        prep
        |> Enum.into(@invalid_attrs)

      assert {:error, %Ecto.Changeset{}} = Scores.create_score(attrs)
    end

    test "update_score/2 with valid data updates the score" do
      score = score_fixture()

      prep = %{player_id: score.player_id, game_id: score.game_id}

      attrs =
        prep
        |> Enum.into(@update_attrs)

      assert {:ok, score} = Scores.update_score(score, attrs)
      assert %Score{} = score
      assert score.score == 40
      assert score.handicap_change == D.new("-1.0")
    end

    test "update_score/2 with invalid data returns error changeset" do
      score = score_fixture()

      assert {:error, %Ecto.Changeset{}} = Scores.update_score(score, @invalid_attrs)
      assert score == Scores.get_score!(score.id)
    end

    test "delete_score/1 deletes the score and reverts handicap" do
      score = score_fixture()

      player = Players.get_player!(score.player_id)
      assert player.handicap == D.new("10.3")

      assert {:ok, %Score{}} = Scores.delete_score(score)
      assert_raise Ecto.NoResultsError, fn -> Scores.get_score!(score.id) end

      player = Players.get_player!(score.player_id)
      assert player.handicap == D.new("10.0")
    end

    test "change_score/1 returns a score changeset" do
      score = score_fixture()
      assert %Ecto.Changeset{} = Scores.change_score(score)
    end
  end
end
