defmodule BattleshipSolitaireSolver.Formation do
  defstruct [
    :cells,
    :counts,
    :placements
  ]

  def new(grid_size) do
    %__MODULE__{
      cells: %{},
      counts: init_counts(grid_size),
      placements: []
    }
  end

  def place_ship(
        %__MODULE__{placements: placements, cells: cells} = formation,
        placement,
        ship_cells
      ) do
    updated_placements = [placement | placements]
    updated_cells = Map.merge(cells, ship_cells)

    %{formation | placements: updated_placements, cells: updated_cells}
  end

  defp init_counts(grid_size) do
    init = 1..grid_size |> Enum.map(fn x -> {x, 0} end) |> Map.new()

    %{
      row_counts: init,
      col_counts: init
    }
  end
end
