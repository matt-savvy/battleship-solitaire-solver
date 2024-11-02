defmodule BattleshipSolitaireSolver.Formation do
  defstruct [
    :placements
  ]

  def new() do
    %__MODULE__{
      placements: []
    }
  end
end
