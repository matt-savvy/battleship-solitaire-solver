# BattleshipSolitaireSolver

Solver for Battleship Solitiare puzzles.

## Sample Solution Times

| tag  | 6x6     | 10x10  |
| ---  | ------- | -----  |
| v1   | ---     |   ---  |
| v1.1 | 1:08    |   ---  |
| v1.2 | 1:01    |   ---  |
| v1.3 | 0:18    |   ---  |
| v1.4 | < 0:01  |   0:10 |
| v1.5 | < 0:01  |   0:05 |
| v1.6 | < 0:01  |   0:02 |
| v1.7 | < 0:01  | < 0:01 |


## Sample Input

```elixir
# 10x10.exs
cells = %{
  {4, 1} => :water,
  {6, 4} => :bottom,
  {9, 4} => :top
}

clues =
  %Clues{
    cells: cells,
    col_counts: %{ 1 => 5, 2 => 1, 3 => 0, 4 => 6, 5 => 1, 6 => 2, 7 => 2, 8 => 1, 9 => 4, 10 => 3 },
    row_counts: %{ 1 => 6, 2 => 0, 3 => 4, 4 => 3, 5 => 3, 6 => 3, 7 => 3, 8 => 0, 9 => 2, 10 => 1 }
  }

grid_size = clues.row_counts |> Enum.count()

ships = [:carrier, :battleship, :cruiser, :cruiser, :destroyer, :destroyer, :destroyer, :buoy, :buoy, :buoy, :buoy]

Solver.get_all_formations(grid_size, clues, ships)
|> IO.inspect()
```

```bash
mix run 10x10.exs
```
