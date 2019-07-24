Chapter 8 Higher-Order Functions and List Comprehensions
  - Higher-order functions, functions that accept other functions as arguments

Simple Higher-Order Functions

  ```Elixir
  iex(5)> ampersand_function = &(20 * &1)
  #Function<6.106461118/1 in :erl_eval.expr/5>
  iex(6)> Hof.tripler(6, ampersand_function)
  360
  iex(7)> Hof.tripler(6, &(20 * &1))
  360
  iex(8)> x = 20
  20
  iex(9)> my_function2 = fn(value) -> x * value end
  #Function<6.106461118/1 in :erl_eval.expr/5>
  iex(10)> x = 0
  0
  iex(11)> my_function2.(6)
  120
  ```

  - Even though the value of x has been changed, the fn preserves the value and can act upon it. (This is called a closure.)

Beyond List Comprehensions
  - The Enum.all?/2 and Enum.any?/2 functions let you test a list against rules you specify in a function.
