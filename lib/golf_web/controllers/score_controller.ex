defmodule GolfWeb.ScoreController do
  use GolfWeb, :controller

  alias Golf.Games
  alias Golf.Players
  alias Golf.Scores

  def new(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    players = Players.players_without_score_for_game_id(game.id)
    csrf = Plug.CSRFProtection.get_csrf_token()

    render(conn, "new.html", game: game, players: players, csrf: csrf)
  end

  def show(conn, %{"id" => id}) do
    score = Scores.get_score!(id)
    player = Players.get_player!(score.player_id)
    render(conn, "show.html", score: score, player: player)
  end

  def edit(conn, %{"id" => id}) do
    score = Scores.get_score!(id)
    changeset = Scores.change_score(score)
    render(conn, "edit.html", score: score, changeset: changeset)
  end

  def update(conn, %{"id" => id, "score" => score_params}) do
    score = Scores.get_score!(id)

    case Scores.update_score(score, score_params) do
      {:ok, score} ->
        conn
        |> put_flash(:info, "Score updated successfully.")
        |> redirect(to: Routes.score_path(conn, :show, score))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", score: score, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    score = Scores.get_score!(id)
    {:ok, _score} = Scores.delete_score(score)

    conn
    |> put_flash(:info, "Score deleted successfully.")
    |> redirect(to: Routes.game_path(conn, :show, score.game_id))
  end

  def create_many(conn, form_params) do
    %{"game_id" => game_id} = form_params

    form_params
    |> Map.delete("game_id")
    |> Map.delete("_csrf_token")
    |> prepare_for_changeset(game_id)
    |> remove_scores_of_zero()
    |> create_scores()

    conn
    |> put_flash(:info, "All scores created successfully.")
    |> redirect(to: Routes.game_path(conn, :show, game_id))
  end

  defp prepare_for_changeset(params, game_id) do
    params
    |> Enum.map(fn {x, y} ->
      %{
        player_id: x,
        game_id: game_id,
        score: String.to_integer(y),
        handicap: 0,
        handicap_change: 0.0,
        points: 1
      }
    end)
  end

  defp remove_scores_of_zero(scores) do
    scores
    |> Enum.filter(fn x ->
      x.score > 0
    end)
  end

  defp create_scores([]), do: []

  defp create_scores([hd | tl]) do
    Scores.create_score(hd)
    create_scores(tl)
  end
end
