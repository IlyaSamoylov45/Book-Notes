defmodule ModuleAttributeTest do
  @test 3
  def sum(r), do: r+@test
  def multiply(r), do: r*@test
end
