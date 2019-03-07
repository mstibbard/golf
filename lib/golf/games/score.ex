defmodule Golf.Games.Score do
  use Ecto.Schema
  import Ecto.Changeset

  schema "scores" do
    field(:score, :integer)
    field(:handicap_change, :decimal)

    belongs_to(:player, Golf.Players.Player)
    belongs_to(:game, Golf.Games.Game)

    timestamps()
  end

  @doc false
  def changeset(score, attrs) do
    score
    |> cast(attrs, [:score, :handicap_change, :player_id, :game_id])
    |> validate_required([:score, :handicap_change, :player_id, :game_id])
  end
end
