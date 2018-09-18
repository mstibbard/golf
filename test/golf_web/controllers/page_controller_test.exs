defmodule GolfWeb.PageControllerTest do
  use GolfWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Please <a href=\"/auth/google?scope=email+profile\">sign in</a>. You will then be able to manage the players, handicaps, and games."
  end
end
