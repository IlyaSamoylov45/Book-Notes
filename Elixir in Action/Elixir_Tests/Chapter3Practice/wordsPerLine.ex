defmodule Lines do
  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.length/1)
    |> Enum.max()
  end
end
