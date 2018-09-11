defmodule Golf.Factory do
  use ExMachina.Ecto, repo: Golf.Repo

  def user_factory do
    %Golf.User{
      token: "fdsfkmghkg;gdf",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: "Wayne",
      provider: "google"
    }
  end
end
