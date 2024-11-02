defmodule BattleshipSolitaireSolver do
  @moduledoc """
  Documentation for `BattleshipSolitaireSolver`.
  """
  alias BattleshipSolitaireSolver.Formation

  def get_all_formations(grid_size, ships) do
    formation = Formation.new()
    do_get_all_formations(grid_size, formation, ships)
  end

  defp do_get_all_formations(grid_size, %Formation{} = formation, [] = _ships) do
    [formation]
  end

  defp do_get_all_formations(grid_size, %Formation{} = formation, [ship | rest_ships]) do
    possible_locs(grid_size, ship)
    |> Enum.flat_map(fn loc ->
      # update formation
      do_get_all_formations(grid_size, formation, rest_ships)
    end)
    |> List.first()
  end

  def possible_locs(grid_size, ship) do
    for col <- 1..grid_size, row <- 1..grid_size do
      {col, row}
    end
  end
end
