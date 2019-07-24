defmodule RangeFinder do
  def range(start, finish) do
    rangeSupport([], start, finish)
  end

  def rangeSupport(list, start, finish) when start <= finish do
      rangeSupport([finish | list], start, finish-1)
  end

  def rangeSupport(list, _, _) do
      list
  end
end
