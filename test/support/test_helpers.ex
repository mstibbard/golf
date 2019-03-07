defmodule Golf.TestHelpers do
  alias Golf.Players
  alias Golf.Games

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
    attrs = 
      attrs
      |> Enum.into(%{
           name: "Namey McNameface",
           active: true,
           handicap: 10.0
         })

    {:ok, player} = Players.create_player(attrs)

    player
  end

  def game_fixture(attrs) do
    {:ok, game} = Games.create_game(attrs)

    game
  end
end
