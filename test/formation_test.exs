defmodule BattleshipSolitaireSolver.FormationTest do
  use ExUnit.Case
  alias BattleshipSolitaireSolver.Formation

  test "new" do
    assert %Formation{
             placements: [],
             counts: counts
           } = Formation.new(5)

    assert %{
             1 => 0,
             2 => 0,
             3 => 0,
             4 => 0,
             5 => 0
           } == counts.col_counts

    assert %{
             1 => 0,
             2 => 0,
             3 => 0,
             4 => 0,
             5 => 0
           } == counts.row_counts
  end
end
