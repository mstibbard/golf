defmodule GolfWeb.ScoreController do
  use GolfWeb, :controller

  alias Golf.Players
  alias Golf.Scores

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
end
