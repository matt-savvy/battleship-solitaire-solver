defmodule BattleshipSolitaireSolver.FormationTest do
  use ExUnit.Case
  alias BattleshipSolitaireSolver.Formation

  test "new" do
    assert %Formation{
             placements: []
           } = Formation.new()
  end
end
