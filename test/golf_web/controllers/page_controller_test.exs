defmodule GolfWeb.PageControllerTest do
  use GolfWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "To view player scores and record games, please sign in with Google."
  end
end
