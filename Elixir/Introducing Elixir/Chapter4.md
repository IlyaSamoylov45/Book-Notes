CHAPTER 4 Logic and Recursion

Logic Inside of Functions
  - Two constructs for evaluating conditions inside of functions:
    1. case : lets you use pattern matching and guards inside of a function clause
    2. cond and if expressions : if construct evaluates only a single guard.

Evaluating Cases
  - The case construct lets you perform pattern matching inside of your function clause.

  ```Elixir
  defmodule Test do
    def case_test(val, x) when x >= 0 do
      case val do     
        :test1 -> :math.sqrt(1 * x)     
        :test2 -> :math.sqrt(2 * x)     
        :test3 -> :math.sqrt(3 * x)    
      end  
    end
  end
  ```

  - You can use case construct to reduce duplicate code

  ```Elixir
  defmodule Test do
    def case_test(val, x) when x >= 0 do
      mult = case val do     
        :test1 -> 1     
        :test2 -> 2     
        :test3 -> 3   
      end  
      :math.sqrt(mult * x)
    end
  end
  ```

Adjusting to Conditions   
  - Cond construct is like the case statement, but without the pattern matching.
  - Cond often makes it easier to express logic based on broader comparisons than simple matching.

  ```Elixir
  defmodule Test do
    def case_test(val, x) when x >= 0 do
      mult = case val do     
        :test1 -> 1     
        :test2 -> 2     
        :test3 -> 3   
      end  
      compare = :math.sqrt(mult * x)

      cond do
        compare == 1 -> :slow
        compare < 3 and compare > 2 -> fasts
      end
    end
  end
  ```

If, or else
  - if function only tests a single clause

  ```Elixir
  defmodule Test do
    def case_test(val, x) when x >= 0 do
      mult = case val do     
        :test1 -> 1     
        :test2 -> 2     
        :test3 -> 3   
      end  
      compare = :math.sqrt(mult * x)

      if compare > 1 do      
        IO.puts("Greater than 1")    
      else      
        IO.puts("Equal to 1")    
      end

      compare

    end
  end
  ```

  -  Elixir lets you put a colon after the do

  ```elixir
  if x>10, do: :big, else: :small
  ```

  - There is also an unless

  ```elixir
  unless x>10, do: :small, else: :large
  ```

Variable Assignment in case and if Constructs
  - Every possible path created in a case, cond, or if statement has the opportunity to bind values to variables. This is usually a wonderful thing, but could let you create unstable programs


The Gentlest Side Effect: IO.puts
  - Elixir best practice suggests using side effects only when you really need to.

Simple Recursion   

Counting Down

Counting Up

Recursing with Return Values
