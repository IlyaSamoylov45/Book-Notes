defmodule Positive do
  def positive([]) do
    []
  end
  def positive([head | tail]) when  is_number(head)  do
    [head | positive(tail)]
  end

  def positive([ _ | tail]) do
    positive(tail)
  end

end
