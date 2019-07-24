defmodule Positive do
  def positive(list) do
    positiveSupport([], list)
    |> Enum.reverse
  end
  def positiveSupport(list, []) do
    list
  end
  def positiveSupport(list, [head | tail]) when is_number(head)  do
    positiveSupport([head | list], tail)
  end

  def positiveSupport(list, [ _ | tail]) do
    positiveSupport(list, tail)
  end

end
