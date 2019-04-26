# Sums all values in a list
defmodule SumList do
  def sum([]) do
    0
  end

  def sum([head | tail]) do
    sum(head) + sum(tail)
  end

  def sum(head) when is_number(head) do
    head
  end

  def sum(_head) do
    0
  end
end
