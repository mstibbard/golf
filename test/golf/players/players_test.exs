defmodule Golf.PlayersTest do
  use Golf.DataCase

  alias Golf.Players
  alias Golf.Players.Player

  describe "players" do
    @valid_attrs %{name: "max", active: true, handicap: 20.0}
    @invalid_attrs %{handicap: "wrong"}

    test "list_players/0 returns all players" do
      # Creates player using player_fixture, binds id1 to the id created by the fixture
      %Player{id: id1} = player_fixture()
      assert [%Player{id: ^id1}] = Players.list_players()
      %Player{id: id2} = player_fixture()
      assert [%Player{id: ^id1}, %Player{id: ^id2}] = Players.list_players()
    end

    test "get_player!/1 returns the player with given id" do
      %Player{id: id} = player_fixture()
      assert %Player{id: ^id} = Players.get_player!(id)
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Players.create_player(@valid_attrs)
      assert player.name == "max"
      assert player.active == true
      assert player.handicap == Decimal.new("20.0")
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Players.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, player} = Players.update_player(player, %{name: "Bobby"})
      assert %Player{} = player
      assert player.name == "Bobby"
    end

    test "update_player/2 with invalid data returns error changeset" do
      %Player{id: id} = player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Players.update_player(player, @invalid_attrs)
      assert %Player{id: ^id} = Players.get_player!(id)
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Players.change_player(player)
    end
  end
end
