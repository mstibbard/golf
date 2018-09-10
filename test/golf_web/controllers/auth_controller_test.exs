defmodule GolfWeb.AuthControllerTest do
  use GolfWeb.ConnCase
  alias Golf.Repo
  alias Golf.User

  @ueberauth_auth %{credentials: %{token: "fsfDFsdgdsgdsfsd"},
                    info: %{
                      email: "batman@example.com",
                      first_name: "Bruce",
                      last_name: "Wayne"},
                      provider: :google
                    }

  test "redirects user to Google for authentication", %{conn: conn} do
    conn = get conn, "/auth/google?scope=email%20profile"
    assert redirected_to(conn, 302)
  end

  test "creates user from Google info", %{conn: conn} do
    conn = conn
      |> assign(:ueberauth_auth, @ueberauth_auth)
      |> get("/auth/google/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    assert get_flash(conn, :info) == "Thank you for signing in!"
  end

end
