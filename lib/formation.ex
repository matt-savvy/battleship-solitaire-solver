defmodule BattleshipSolitaireSolver.Formation do
  defstruct [
    :grid_size,
    :cells,
    :counts,
    :placements
  ]

  def new(grid_size) do
    %__MODULE__{
      grid_size: grid_size,
      cells: %{},
      counts: init_counts(grid_size),
      placements: []
    }
  end

  def place_ship(
        %__MODULE__{placements: placements, grid_size: grid_size, cells: cells, counts: counts} =
          formation,
        placement,
        ship_cells
      ) do
    updated_placements = [placement | placements]
    updated_cells = update_cells(grid_size, cells, ship_cells)
    updated_counts = update_counts(counts, ship_cells)

    %{formation | placements: updated_placements, cells: updated_cells, counts: updated_counts}
  end

  defp init_counts(grid_size) do
    init = 1..grid_size |> Enum.map(fn x -> {x, 0} end) |> Map.new()

    %{
      row_counts: init,
      col_counts: init
    }
  end

  defp update_cells(grid_size, cells, ship_cells) do
    water_cells =
      surrounding_coords(grid_size, ship_cells)
      |> Enum.map(fn coords -> {coords, :water} end)
      |> Map.new()

    cells
    |> Map.merge(water_cells)
    |> Map.merge(ship_cells)
  end

  defp surrounding_coords(grid_size, ship_cells) do
    ship_cells
    |> Map.keys()
    |> Enum.flat_map(fn {col, row} ->
      for c <- (col - 1)..(col + 1),
          r <- (row - 1)..(row + 1),
          not Map.has_key?(ship_cells, {c, r}) do
        {c, r}
      end
    end)
    |> Enum.uniq()
    |> Enum.filter(fn {col, row} ->
      col > 0 and
        col <= grid_size and
        row > 0 and
        row <= grid_size
    end)
  end

  defp update_counts(counts, ship_cells) do
    ship_cells
    |> Map.keys()
    |> Enum.reduce(counts, fn {col, row}, acc ->
      acc
      |> Kernel.update_in([:row_counts, row], &(&1 + 1))
      |> Kernel.update_in([:col_counts, col], &(&1 + 1))
    end)
  end
end
