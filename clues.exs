alias BattleshipSolitaireSolver.Clues

[filename] = System.argv()
clues_json = File.read!(filename)

decode_counts = fn counts_str ->
  counts_str
  |> Enum.map(fn {k, v} ->
    key = String.to_integer(k)
    {key, v}
  end)
  |> Map.new()
end

:json.decode(clues_json)
|> Map.update!("cells", fn cells ->
  cells
  |> Enum.map(fn {k, v} ->
    [col, row] = String.split(k, ",") |> Enum.map(&String.to_integer/1)
    {{col, row}, String.to_atom(v)}
  end)
  |> Map.new()
end)
|> Map.update!("row_counts", decode_counts)
|> Map.update!("col_counts", decode_counts)
|> Enum.map(fn {k, v} ->
  {String.to_atom(k), v}
end)
|> Map.new()
|> then(&struct(Clues, &1))
|> IO.inspect()
