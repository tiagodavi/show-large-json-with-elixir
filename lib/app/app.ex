defmodule App do
  @moduledoc """
  Public API to access Players.
  """

  alias App.Players.Player

  @default_total 5

  @doc """
  Gets Players from Json file.
  Examples:

  Get 3 players: App.load(total: 3)
  Get next 3 players:  App.load(total: 3, offset: 3)
  Filter by Player's field:  App.load(total: 3, filter: {"Player", "Robert"})
  Sort by Player's field:  App.load(total: 3, sort: {:td, :asc})
  """
  @spec load(keyword) :: list(Player.t())
  def load(args) do
    load_json_file(args)
  end

  @doc """
  Builds a two-dimensional list to export as csv
  """
  @spec to_csv(list(Player.t())) :: String.t()
  def to_csv(players) do
    header = [
      "Index",
      "Player",
      "Team",
      "Pos",
      "Att/G",
      "Att",
      "Yds",
      "Avg",
      "Yds/G",
      "TD",
      "Lng",
      "1st",
      "1st%",
      "20+",
      "40+",
      "FUM"
    ]

    players =
      Enum.map(players, fn p ->
        [
          p.index,
          p.player,
          p.team,
          p.pos,
          p.att_g,
          p.att,
          p.yds,
          p.avg,
          p.yds_g,
          p.td,
          p.lng,
          p._1_st,
          p._1_st_perc,
          p._20_plus,
          p._40_plus,
          p.fum
        ]
      end)

    [header | players]
    |> CSV.encode()
    |> Enum.to_list()
    |> to_string()
  end

  defp load_json_file(args) do
    "priv/resources/rushing.json"
    |> File.stream!()
    |> Jaxon.Stream.query(Jaxon.Path.parse!("$[*]"))
    |> filter(args)
    |> Stream.with_index()
    |> reject(args)
    |> take(args)
    |> Stream.map(&build_player/1)
    |> sort(args)
  end

  defp build_player({item, index}) do
    Player.new(item, index)
  end

  defp reject(stream, args) do
    if args[:offset] do
      Stream.reject(stream, fn {_, index} -> index < args[:offset] end)
    else
      stream
    end
  end

  defp take(stream, args) do
    Stream.take(stream, args[:total] || @default_total)
  end

  defp filter(stream, args) do
    if args[:filter] do
      {field, target} = args[:filter]
      target = String.downcase(target)

      Stream.filter(stream, fn p ->
        field =
          Map.get(p, field)
          |> String.downcase()

        String.contains?(field, target)
      end)
    else
      stream
    end
  end

  defp sort(stream, args) do
    if args[:sort] do
      {field, direction} = args[:sort]

      Enum.sort(stream, fn x, y ->
        {x, _} =
          Map.get(x, field)
          |> to_string()
          |> Float.parse()

        {y, _} =
          Map.get(y, field)
          |> to_string()
          |> Float.parse()

        if direction == :asc do
          x <= y
        else
          x >= y
        end
      end)
    else
      Enum.to_list(stream)
    end
  end
end
