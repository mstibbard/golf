defmodule Golf.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field(:score, :integer)
    field(:handicap, :decimal)
    field(:handicap_change, :decimal)
    field(:points, :integer)

    belongs_to(:player, Golf.Players.Player)
    belongs_to(:game, Golf.Games.Game)

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score, :handicap, :handicap_change, :player_id, :game_id, :points])
    |> validate_required([
      :score,
      :handicap,
      :handicap_change,
      :player_id,
      :game_id,
      :points
    ])
  end
end
