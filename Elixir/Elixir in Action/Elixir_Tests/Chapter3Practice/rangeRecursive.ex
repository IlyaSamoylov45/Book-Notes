defmodule RangeFinder do
  def range(start, finish) when start < finish do
    [start] ++ range(start+1,finish)
  end
  def range(_, _) do
      []
  end
end
