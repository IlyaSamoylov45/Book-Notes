# Sums all values in a list
defmodule FlattenList do
  def flat([]) do
    []
  end

  def flat([ head | tail ]) do
    flat(head) ++ flat(tail)
  end

  def flat(head) do
    [head]
  end
end

defmodule ReverseList do
  def reverse([]) do
    []
  end

  def reverse([ head | tail ]) do
    reverse(tail) ++ reverse(head)
  end

  def reverse(head) when is_number(head) do
    [head * head]
  end

  def reverse(head) do
    [head]
  end

end
