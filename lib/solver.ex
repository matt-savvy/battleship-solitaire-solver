defmodule BattleshipSolitaireSolver do
  @moduledoc """
  Documentation for `BattleshipSolitaireSolver`.
  """
  alias BattleshipSolitaireSolver.Clues
  alias BattleshipSolitaireSolver.Formation

  def get_all_formations(grid_size, clues, ships) do
    formation =
      Formation.new(grid_size)
      |> Formation.apply_count_clues(clues)
      |> Formation.apply_cell_clues(clues)

    do_get_all_formations(clues, formation, ships)
    |> List.first()
  end

  defp do_get_all_formations(
         _clues,
         %Formation{} = formation,
         [] = _ships
       ) do
    [formation]
  end

  defp do_get_all_formations(clues, %Formation{grid_size: grid_size, cells: cells} = formation, [
         ship | rest_ships
       ]) do
    final = length(rest_ships) == 0

    possible_locs(ship, formation)
    |> Enum.map(fn {coords, orientation} ->
      placement = {ship, coords, orientation}
      ship_cells = ship_cells(placement)

      {placement, ship_cells}
    end)
    |> Enum.filter(fn {_placement, ship_cells} ->
      all_cells_available?(ship_cells, cells, grid_size)
    end)
    |> Enum.map(fn {placement, ship_cells} ->
      formation |> Formation.place_ship(placement, ship_cells)
    end)
    |> Enum.filter(fn %{counts: counts, cells: cells} ->
      satisfies_all_counts?(clues, counts, final) and
        satisfies_all_cells?(clues, cells, final)
    end)
    |> Enum.flat_map(fn formation ->
      do_get_all_formations(clues, formation, rest_ships)
    end)
  end

  defp possible_locs(ship, %Formation{
         grid_size: grid_size,
         placements: [{ship, {last_col, last_row}, _last_orientation} | _rest]
       }) do
    for col <- 1..grid_size,
        row <- 1..grid_size,
        orientation <- orientations_for_ship(ship),
        {col, row} > {last_col, last_row} do
      {{col, row}, orientation}
    end
  end

  defp possible_locs(ship, %Formation{grid_size: grid_size}) do
    for col <- 1..grid_size, row <- 1..grid_size, orientation <- orientations_for_ship(ship) do
      {{col, row}, orientation}
    end
  end

  def orientations_for_ship(:buoy), do: [:vertical]
  def orientations_for_ship(_ship), do: [:vertical, :horizontal]

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

    ship_values = [:left | List.duplicate(:body, size - 2)] ++ [:right]

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

  defp satisfies_all_counts?(%Clues{} = clues, counts, final) do
    satisfies_counts?(clues, counts, :col_counts, final) and
      satisfies_counts?(clues, counts, :row_counts, final)
  end

  defp satisfies_counts?(clues, counts, field, final) do
    compare_fn =
      case final do
        true -> &Kernel.==/2
        false -> &Kernel.<=/2
      end

    clues
    |> Map.get(field)
    |> Enum.all?(fn {key, count} ->
      compare_fn.(Map.get(counts[field], key), count)
    end)
  end

  defp satisfies_all_cells?(%Clues{cells: clue_cells}, cells, false = _final) do
    Enum.all?(clue_cells, fn {coords, value} ->
      not Map.has_key?(cells, coords) or Map.get(cells, coords, :water) == value
    end)
  end

  defp satisfies_all_cells?(%Clues{cells: clue_cells}, cells, true = _final) do
    Enum.all?(clue_cells, fn {coords, value} ->
      Map.get(cells, coords, :water) == value
    end)
  end
end
