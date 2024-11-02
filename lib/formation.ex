defmodule BattleshipSolitaireSolver.Formation do
  defstruct [
    :cells,
    :placements
  ]

  def new() do
    %__MODULE__{
      cells: %{},
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
end
