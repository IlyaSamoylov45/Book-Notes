defmodule ListLength do
  def list_len(list) do
    list_len_helper(0, list)
  end

  def list_len_helper(sum, []) do
    sum
  end

  def list_len_helper(sum, [head | tail]) do
    list_len_helper(sum+1, tail)
  end
end
