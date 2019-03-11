defmodule Golf.Players do
  @moduledoc """
  The Players context."
  """
  alias Golf.Repo
  alias Golf.Players.Player

  def list_players() do
    players_ascending()
  end

  def get_player(id), do: Repo.get(Player, id)
  def get_player!(id), do: Repo.get(Player, id)

  def get_player_by(params), do: Repo.get_by(Player, params)

  def change_player(%Player{} = player), do: Player.changeset(player, %{})

  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  def players_ascending() do
    Player
    |> Player.players_alphabetically()
    |> Repo.all()
  end

  def list_active_players() do
    Player
    |> Player.active_players()
    |> Player.players_alphabetically()
    |> Repo.all()
  end

  def players_without_score_for_game_id(game_id) do
    base = 
      Player
      |> Player.active_players()

    to_remove = 
      base
      |> Player.existing_score(game_id)

    base
    |> Player.remove_existing(to_remove)
    |> Player.players_alphabetically_sub()
    |> Repo.all() 
  end
end
