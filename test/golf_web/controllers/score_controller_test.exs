defmodule GolfWeb.ScoreControllerTest do
  use GolfWeb.ConnCase

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.score_path(conn, :new, "1")),
        get(conn, Routes.score_path(conn, :show, "123")),
        get(conn, Routes.score_path(conn, :edit, "123")),
        put(conn, Routes.score_path(conn, :update, "123", %{})),
        post(conn, Routes.score_path(conn, :create, %{})),
        delete(conn, Routes.score_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
    end)
  end

  describe "with a LOGGED-IN user" do
    setup %{conn: conn} do
      user = user_factory()
      conn = assign(conn, :user, user)

      {:ok, conn: conn, user: user}
    end

    test "create score screen loads active players only", %{conn: conn} do
      game = game_fixture()
      player1 = player_fixture(%{name: "Bobby"})
      player2 = player_fixture(%{name: "Jane"})
      player3 = player_fixture(%{name: "Away", active: false})

      conn = get(conn, Routes.score_path(conn, :new, game.id))
      assert String.contains?(conn.resp_body, player1.name)
      assert String.contains?(conn.resp_body, player2.name)
      refute String.contains?(conn.resp_body, player3.name)
    end
  end
end
