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

  def place_ship(%__MODULE__{placements: placements} = formation, placement) do
    updated_placements = [placement | placements]

    %{formation | placements: updated_placements}
  end
end
