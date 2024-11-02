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
    |> Enum.filter(fn placement ->
      ship_cells = ship_cells(placement)

      all_cells_available?(ship_cells, grid_size)
    end)
    |> Enum.flat_map(fn placement ->
      formation = formation |> Formation.place_ship(placement)

      do_get_all_formations(grid_size, formation, rest_ships)
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
    |> Enum.map(fn row -> {col, row} end)
  end

  defp ship_cells({ship, {col, row}, :horizontal}) do
    size = ship_size(ship)

    col..(col + size - 1)
    |> Enum.map(fn col -> {col, row} end)
  end

  defp ship_size(:battleship), do: 4
  defp ship_size(:cruiser), do: 3

  defp all_cells_available?(ship_cells, grid_size) do
    Enum.all?(ship_cells, fn {col, row} ->
      col > 0 and
        col <= grid_size and
        row > 0 and
        row <= grid_size
    end)
  end
end
