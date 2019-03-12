defmodule GolfWeb.PageController do
  use GolfWeb, :controller

  alias Golf.Players

  def index(conn, _params) do
    div1 = Players.get_division(0, 27)
    div2 = Players.get_division(28, 36)
    div3 = Players.get_division(37, 45)
    render(conn, "index.html", div1: div1, div2: div2, div3: div3)
  end

  def print(conn, _params) do
    div1 = Players.get_division(0, 27)
    div2 = Players.get_division(28, 36)
    div3 = Players.get_division(37, 45)
    render(conn, "print.html", div1: div1, div2: div2, div3: div3)
  end
end
