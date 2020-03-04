defmodule AppWeb.PageController do
  use AppWeb, :controller

  @players_per_page 50

  def index(conn, params) do
    args = handle_params(params)
    players = App.load(args)

    if params["export"] do
      render_csv(conn, players)
    else
      assigns =
        [
          players: players,
          sort: params["sort"],
          filter: params["filter"]
        ] ++ build_pagination(players, params)

      render(conn, "index.html", assigns)
    end
  end

  defp render_csv(conn, players) do
    conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("content-disposition", "attachment; filename=\"Players.csv\"")
    |> send_resp(200, App.to_csv(players))
  end

  defp handle_params(params) do
    params
    |> handle_filter()
    |> handle_sort(params)
    |> handle_pagination(params)
  end

  defp handle_filter(%{"filter" => filter}) do
    if String.length(filter) > 0 do
      [filter: {"Player", filter}]
    else
      []
    end
  end

  defp handle_filter(_), do: []

  defp handle_sort(args, %{"sort" => sort}) do
    if String.length(sort) > 0 do
      case sort do
        "yds-up" ->
          args ++ [sort: {:yds, :desc}]

        "yds-down" ->
          args ++ [sort: {:yds, :asc}]

        "td-up" ->
          args ++ [sort: {:td, :desc}]

        "td-down" ->
          args ++ [sort: {:td, :asc}]

        "lng-up" ->
          args ++ [sort: {:lng, :desc}]

        "lng-down" ->
          args ++ [sort: {:lng, :asc}]

        "index-up" ->
          args ++ [sort: {:index, :desc}]

        "index-down" ->
          args ++ [sort: {:index, :asc}]

        _ ->
          args
      end
    else
      args
    end
  end

  defp handle_sort(args, _), do: args

  defp handle_pagination(args, %{"offset" => offset}) do
    if String.length(offset) > 0 do
      offset = String.to_integer(offset)
      args ++ [total: @players_per_page, offset: offset]
    else
      args
    end
  end

  defp handle_pagination(args, _), do: args ++ [total: @players_per_page]

  defp build_pagination(players, %{"offset" => offset}) do
    if String.length(offset) > 0 do
      offset = String.to_integer(offset) - @players_per_page
      offset = if offset <= 0, do: 0, else: offset

      pagination(players, offset)
    else
      pagination(players, 0)
    end
  end

  defp build_pagination(players, _params) do
    pagination(players, 0)
  end

  defp pagination(players, offset) do
    if Enum.empty?(players) do
      [previous: 0, next: 0]
    else
      max_index_player = Enum.max_by(players, & &1.index)
      [previous: offset, next: max_index_player.index + 1]
    end
  end
end
