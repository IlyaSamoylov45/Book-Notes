defmodule Lines do
  def lines_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.length/1)
  end
end
