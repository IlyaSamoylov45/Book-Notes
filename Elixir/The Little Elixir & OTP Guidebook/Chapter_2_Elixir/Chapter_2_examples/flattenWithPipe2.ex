# Sums all values in a list
defmodule FlattenList do
  def flat([]) do
    []
  end

  def flat([ head | tail ]) do
    flat(tail) ++ flat(head)
  end

  def flat(head) when is_number(head) do
    [head * head]
  end

  def flat(head) do
    [head]
  end

end
