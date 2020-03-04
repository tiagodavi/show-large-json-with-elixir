defmodule App.Players.Player do
  @moduledoc """
  This module represents a team player.
  """

  defstruct [
    :player,
    :pos,
    :team,
    :att,
    :att_g,
    :yds,
    :avg,
    :yds_g,
    :td,
    :lng,
    :_1_st,
    :_1_st_perc,
    :_20_plus,
    :_40_plus,
    :fum,
    :index
  ]

  @type t :: %__MODULE__{}

  @doc """
   Creates a Player Structure
  """
  @spec new(String.t(), Integer.t()) :: __MODULE__.t()
  def new(item, index) do
    %__MODULE__{
      player: item["Player"],
      team: item["Team"],
      pos: item["Pos"],
      att_g: item["Att/G"],
      att: item["Att"],
      yds: item["Yds"],
      avg: item["Avg"],
      yds_g: item["Yds/G"],
      td: item["TD"],
      lng: item["Lng"],
      _1_st: item["1st"],
      _1_st_perc: item["1st%"],
      _20_plus: item["20+"],
      _40_plus: item["40+"],
      fum: item["FUM"],
      index: index
    }
  end

  @doc """
   Check if it's a Player
   returns true
  """
  @spec is_player?(__MODULE__.t()) :: boolean()
  def is_player?(%__MODULE__{}), do: true

  @doc """
   Check if it's a Player
   returns false
  """
  @spec is_player?(any()) :: boolean()
  def is_player?(_), do: false
end
