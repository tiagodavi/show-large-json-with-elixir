defmodule AppTest do
  use ExUnit.Case, async: true

  alias App.Players.Player

  test "loads 3 players" do
    players = App.load(total: 3, offset: 0)

    assert Enum.count(players, &Player.is_player?/1) == 3
  end

  test "loads next 3 players" do
    players =
      App.load(total: 3, offset: 0)
      |> Enum.map(& &1.index)

    next_players =
      App.load(total: 3, offset: 3)
      |> Enum.map(& &1.index)

    elements =
      (players ++ next_players)
      |> Enum.uniq()

    assert length(elements) == 6
  end

  test "filters 3 players by name" do
    name = "Aa"
    players = App.load(total: 3, filter: {"Player", name})

    total =
      Enum.count(players, fn p ->
        String.downcase(p.player)
        |> String.contains?(String.downcase(name))
      end)

    assert total == 3
  end

  test "sorts 3 players by Total Rushing Yards" do
    [a, b, c | []] = App.load(total: 3, sort: {:yds, :asc})

    assert a.yds <= b.yds && b.yds <= c.yds == true
  end

  test "builds a csv string for 3 players" do
    players =
      App.load(total: 3, offset: 0, sort: {:td, :asc})
      |> App.to_csv()

    assert is_binary(players) == true
  end
end
