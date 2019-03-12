defmodule GolfWeb.DivisionsTest do
  use GolfWeb.ConnCase, async: true

  describe "divisions" do
    setup %{conn: conn} do
      user = user_factory()
      conn = assign(conn, :user, user)

      {:ok, conn: conn, user: user}
    end

    test "handicaps are rounded correctly" do
      p1 = player_fixture(%{name: "Jo", handicap: 31.5})
      p2 = player_fixture(%{name: "Hum", handicap: 31.4})

      conn = get(conn, Routes.page_path(conn, :index))
      assert String.contains?(conn.resp_body, "Jo</td><td>32")
      assert String.contains?(conn.resp_body, "Hum</td><td>31")
    end    
  end
end

