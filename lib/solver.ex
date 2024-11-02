defmodule BattleshipSolitaireSolver do
  @moduledoc """
  Documentation for `BattleshipSolitaireSolver`.
  """
  alias BattleshipSolitaireSolver.Formation

  def get_all_formations(grid_size, ships) do
    formation = Formation.new()

    do_get_all_formations(grid_size, formation, ships)
    |> List.first()
  end

  defp do_get_all_formations(_grid_size, %Formation{} = formation, [] = _ships) do
    [formation]
  end

  defp do_get_all_formations(grid_size, %Formation{} = formation, [ship | rest_ships]) do
    possible_locs(grid_size, ship)
    |> Enum.map(fn {coords, orientation} ->
      {ship, coords, orientation}
    end)
    |> Enum.flat_map(fn placement ->
      formation = formation |> Formation.place_ship(placement)

      do_get_all_formations(grid_size, formation, rest_ships)
    end)
  end

  def possible_locs(grid_size, _ship) do
    for col <- 1..grid_size, row <- 1..grid_size, orientation <- [:vertical, :horizontal] do
      {{col, row}, orientation}
    end
  end
end
