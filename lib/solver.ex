defmodule BattleshipSolitaireSolver do
  @moduledoc """
  Documentation for `BattleshipSolitaireSolver`.
  """
  alias BattleshipSolitaireSolver.Clues
  alias BattleshipSolitaireSolver.Formation

  def get_all_formations(grid_size, clues, ships) do
    formation = Formation.new(grid_size)

    do_get_all_formations(grid_size, clues, formation, ships)
    |> List.last()
  end

  defp do_get_all_formations(_grid_size, clues, %Formation{} = formation, [] = _ships) do
    [formation]
  end

  defp do_get_all_formations(grid_size, clues, %Formation{cells: cells} = formation, [
         ship | rest_ships
       ]) do
    possible_locs(grid_size, ship)
    |> Enum.map(fn {coords, orientation} ->
      placement = {ship, coords, orientation}
      ship_cells = ship_cells(placement)

      {placement, ship_cells}
    end)
    |> Enum.filter(fn {_placement, ship_cells} ->
      all_cells_available?(ship_cells, cells, grid_size)
    end)
    |> Enum.flat_map(fn {placement, ship_cells} ->
      formation = formation |> Formation.place_ship(placement, ship_cells)

      do_get_all_formations(grid_size, clues, formation, rest_ships)
    end)
  end

  defp possible_locs(grid_size, _ship) do
    for col <- 1..grid_size, row <- 1..grid_size, orientation <- [:vertical, :horizontal] do
      {{col, row}, orientation}
    end
  end

  defp ship_cells({ship, {col, row}, :vertical}) do
    size = ship_size(ship)

    row..(row + size - 1)
    |> Enum.map(fn row -> {{col, row}, ship} end)
    |> Map.new()
  end

  defp ship_cells({ship, {col, row}, :horizontal}) do
    size = ship_size(ship)

    col..(col + size - 1)
    |> Enum.map(fn col -> {{col, row}, ship} end)
    |> Map.new()
  end

  defp ship_size(:battleship), do: 4
  defp ship_size(:cruiser), do: 3

  defp all_cells_available?(ship_cells, cells, grid_size) do
    ship_cells
    |> Map.keys()
    |> Enum.all?(fn {col, row} = coords ->
      col > 0 and
        col <= grid_size and
        row > 0 and
        row <= grid_size and
        Map.get(cells, coords, :empty) == :empty
    end)
  end
end
