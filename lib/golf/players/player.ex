defmodule Golf.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "players" do
    field(:name, :string)
    field(:active, :boolean)
    field(:handicap, :decimal)

    has_many(:score, Golf.Games.Score)

    timestamps()
  end

  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :active, :handicap])
    |> validate_required([:name, :active, :handicap])
  end

  def active_players(query) do
    from(p in query, where: p.active == :true)
  end

  def players_alphabetically(query) do
    from(p in query, order_by: [asc: p.name])
  end

  # def unique_players_for_game(query, game_id) do
  #   from(p in query,
  #        join: c in assoc(p, :score),
  #        where: c.game_id != game_id)
  # end
end
