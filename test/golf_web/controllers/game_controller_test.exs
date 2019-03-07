defmodule GolfWeb.GameControllerTest do
  use GolfWeb.ConnCase

  @create_attrs %{date: ~D[2010-04-17], type: "some type"}
  @invalid_attrs %{date: nil, type: nil}

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.game_path(conn, :new)),
        get(conn, Routes.game_path(conn, :index)),
        get(conn, Routes.game_path(conn, :show, "123")),
        get(conn, Routes.game_path(conn, :edit, "123")),
        put(conn, Routes.game_path(conn, :update, "123", %{})),
        post(conn, Routes.game_path(conn, :create, %{})),
        delete(conn, Routes.game_path(conn, :delete, "123"))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "with a LOGGED-IN user" do
    setup %{conn: conn} do
      user = user_factory()
      conn = assign(conn, :user, user)

      {:ok, conn: conn, user: user}
    end

    test "lists all games on index", %{conn: conn} do
      game = game_fixture(@create_attrs)

      conn = get(conn, Routes.game_path(conn, :index))
      assert html_response(conn, 200) =~ ~r/Listing Games/
      assert String.contains?(conn.resp_body, game.type)
    end

    test "creates game and redirects", %{conn: conn} do
      create_conn = post(conn, Routes.game_path(conn, :create), game: @create_attrs)

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.game_path(create_conn, :show, id)

      conn = get(conn, Routes.game_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Game"
    end

    test "does not create game and renders errors when invalid", %{conn: conn} do
      conn = post(conn, Routes.game_path(conn, :create), game: @invalid_attrs)
      assert html_response(conn, 200) =~ "check the errors"
    end
  end
end
