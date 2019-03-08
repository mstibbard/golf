defmodule Golf.TestHelpers do
  alias Golf.Players
  alias Golf.Games
  alias Golf.Scores

  use ExMachina.Ecto, repo: Golf.Repo

  def user_factory do
    %Golf.User{
      token: "fdsfkmghkg;gdf",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end

  def player_fixture(attrs \\ %{}) do
    {:ok, player} =
      attrs
      |> Enum.into(%{
        name: "Namey McNameface",
        active: true,
        handicap: 10.0
      })
      |> Players.create_player()

    player
  end

  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        date: ~D[2019-03-04],
        type: "Stableford"
      })
      |> Games.create_game()

    game
  end

  def score_fixture(attrs \\ %{}) do
    game = game_fixture()
    player = player_fixture()

    {:ok, score} =
      attrs
      |> Enum.into(%{
        score: 36,
        handicap_change: 0.0,
        points: 1,
        player_id: player.id,
        game_id: game.id
      })
      |> Scores.create_score()

    score
  end
end
