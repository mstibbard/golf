defmodule Golf.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias GolfWeb.Router.Helpers, as: Routes

  alias Golf.Repo
  alias Golf.User

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      user_id = get_session(conn, :user_id)

      cond do
        user = user_id && Repo.get(User, user_id) ->
          assign(conn, :user, user)

        true ->
          assign(conn, :user, nil)
      end
    end
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page.")
      |> redirect(to: Routes.page_path(conn, :index))
      |> halt()
    end
  end
end
