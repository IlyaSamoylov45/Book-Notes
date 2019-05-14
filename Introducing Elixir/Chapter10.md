CHAPTER 10 Exceptions, Errors, and Debugging

Flavors of Errors

Rescuing Code from Runtime Errors as They Happen
  - The try…rescue construct lets you wrap suspect code and handle problems (if any) that code creates

  ```Elixir
  try do      
    :math.sqrt(2 * gravity * distance)    
  rescue     
     _error -> _error
  end
  ```
  - The CaseClauseError indicates that a case failed to match and tells you the actual item that didn’t match.
  ```elixir
  defmodule Drop do  
    def fall(planet, dist) do    
      try do      
        g = case planet do        
          :x -> 9.8        
          :y -> 1.6        
          :z -> 3.71
        end      
        :math.sqrt(2 * g * dist)   
      rescue      
        ArithmeticError -> {:error, "Must be non-negative"}      
        CaseClauseError -> {:error, "Unknown planet #{planet}"}    
      end  
    end
  end
  ```

  - If the code that might fail can create a mess, you may want to include an after clause after the rescue clause and before the closing end.

Logging Progress and Failure
  - These functions in Elixir’s Logger module give you four levels of reporting:
    - :info
      - For information of any kind.
    - :debug
      - For debug-related messages.
    - :warn
      - For news that’s worse. Someone should do something eventually.
    - :error
      - Something just plain broke and needs to be looked at.

Tracing Messages
  - The << pointing to a pid indicates that that process received a message.
  - Sends are indicated with the pid followed by ! followed by the message.

Watching Function Calls
  - :dbg will let you see the actual function calls and their arguments, mixed with the IO.puts reporting.

Writing Unit Tests
   - Elixir has a unit-testing module named ExUnit
   - You write your tests in an Elixir script file (with an extension of .exs) so that it doesn’t need to be compiled.
   - In addition to assert/1, you may also use refute/1, which expects the condition you are testing to be false in order for a test to pass.
   - If you are using floating-point operations, you may not be able to count on an exact result. In that case, you can use the assert_in_delta/4 function.
