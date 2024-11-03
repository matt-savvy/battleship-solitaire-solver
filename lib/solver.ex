defmodule BattleshipSolitaireSolver do
  @moduledoc """
  Documentation for `BattleshipSolitaireSolver`.
  """
  alias BattleshipSolitaireSolver.Clues
  alias BattleshipSolitaireSolver.Formation

  def get_all_formations(grid_size, clues, ships) do
    formation = Formation.new(grid_size) |> Formation.apply_count_clues(clues)

    do_get_all_formations(clues, formation, ships)
    |> List.first()
  end

  defp do_get_all_formations(
         clues,
         %Formation{counts: counts, cells: cells} = formation,
         [] = _ships
       ) do
    [formation]
    |> Enum.filter(fn _formation ->
      satisfies_all_counts?(clues, counts) and
        satisfies_all_cells?(clues, cells)
    end)
  end

  defp do_get_all_formations(clues, %Formation{grid_size: grid_size, cells: cells} = formation, [
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

      do_get_all_formations(clues, formation, rest_ships)
    end)
  end

  defp possible_locs(grid_size, _ship) do
    for col <- 1..grid_size, row <- 1..grid_size, orientation <- [:vertical, :horizontal] do
      {{col, row}, orientation}
    end
  end

  defp ship_cells({ship, {col, row}, :vertical}) do
    size = ship_size(ship)

    ship_values =
      case ship do
        :buoy -> [:buoy]
        _ship -> [:top | List.duplicate(:body, size - 2)] ++ [:bottom]
      end

    row..(row + size - 1)
    |> Enum.zip(ship_values)
    |> Enum.map(fn {row, value} -> {{col, row}, value} end)
    |> Map.new()
  end

  defp ship_cells({ship, {col, row}, :horizontal}) do
    size = ship_size(ship)

    ship_values =
      case ship do
        :buoy -> [:buoy]
        _ship -> [:left | List.duplicate(:body, size - 2)] ++ [:right]
      end

    col..(col + size - 1)
    |> Enum.zip(ship_values)
    |> Enum.map(fn {col, value} -> {{col, row}, value} end)
    |> Map.new()
  end

  defp ship_size(:carrier), do: 5
  defp ship_size(:battleship), do: 4
  defp ship_size(:cruiser), do: 3
  defp ship_size(:destroyer), do: 2
  defp ship_size(:buoy), do: 1

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

  defp satisfies_all_counts?(%Clues{} = clues, counts) do
    satisfies_counts?(clues, counts, :col_counts) and
      satisfies_counts?(clues, counts, :row_counts)
  end

  defp satisfies_counts?(clues, counts, field) do
    clues
    |> Map.get(field)
    |> Enum.all?(fn {key, count} ->
      Map.get(counts[field], key) == count
    end)
  end

  defp satisfies_all_cells?(%Clues{cells: clue_cells}, cells) do
    Enum.all?(clue_cells, fn {coords, value} ->
      Map.get(cells, coords, :water) == value
    end)
  end
end
