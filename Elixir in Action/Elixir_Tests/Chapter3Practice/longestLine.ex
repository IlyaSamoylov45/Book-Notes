defmodule Lines do
  def longest_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split/1)
    |> Enum.map(&Enum.count/1)
    end
end
