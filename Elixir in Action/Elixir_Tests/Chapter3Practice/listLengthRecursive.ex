defmodule ListLength do
  def list_len([]) do
    0
  end

  def list_len([head | tail]) do
    1 + list_len(tail)
  end
end
