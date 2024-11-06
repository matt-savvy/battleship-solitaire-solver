defmodule BattleshipSolitaireSolver.Json do
  alias BattleshipSolitaireSolver.Formation

  def to_json(%Formation{placements: placements}) do
    placements
    |> Enum.flat_map(&ship_cells/1)
    |> Enum.map(fn {col, row} -> "Cell#{col}_#{row}" end)
  end

  defp ship_cells({ship, {col, row}, :vertical}) do
    col = col - 1
    row = row - 1

    size = ship_size(ship)

    row..(row + size - 1)
    |> Enum.map(fn row -> {col, row} end)
  end

  defp ship_cells({ship, {col, row}, :horizontal}) do
    col = col - 1
    row = row - 1
    size = ship_size(ship)

    col..(col + size - 1)
    |> Enum.map(fn col -> {col, row} end)
  end

  defp ship_size(:carrier), do: 5
  defp ship_size(:battleship), do: 4
  defp ship_size(:cruiser), do: 3
  defp ship_size(:destroyer), do: 2
  defp ship_size(:buoy), do: 1
end
