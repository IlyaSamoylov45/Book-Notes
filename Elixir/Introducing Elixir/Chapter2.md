CHAPTER 2 Functions and Modules

Fun with fn
  - You can create functions in IEx using the keyword fn.

  ```elixir
  iex> fall = fn(x) -> x*x end
  iex> fall.(2)
  ```

  - You need the period between the variable name and the argument when you call a function that is stored in a variable
  - This style of function is called an anonymous function because the function itself doesn’t have a name.
    - Useful for passing functions as args to other functions.

And the &
  -  &, the capture operator: shortcut style for defining anonymous functions

  ```elixir
  iex> fall = &(&1*&2)
  iex> fall.(2, 2)
  ```
Defining Modules
  - One liner:

  ```elixir
    defmodule Fall do
      def fall(x), do: x * x
    end
  ```

  - def must be declared within a module.
  - Any functions you declare with def will be visible outside of the module and can be called by other code.
  - You can use defp instead of def, and they will be private to the module.
  - The c function lets you compile code.

  ```elixir
  iex> c("name.ex")
  ```

    -  with this you can quit the shell, return, and still use the compiled functions
  -  You can put a series of commands for IEx in a .exs (for Elixir script) file. When you call the c function with that file, Elixir will execute all of the commands in it.
  - You can specify the function to retrieve with a single argument in the form Module_name.function_name/ arity.
  ```elixir
  iex> fun = &Fall.fall/1
  ```

Splitting Code Across Modules

Combining Functions with the Pipe Operator
  - The pipe operator, sometimes called pipe forward
    |>
  - The pipe operator only passes one result into the next function as its first parameter.

Importing Functions
  - Importing entire modules might create conflicts so Elixir lets you specify which functions you want with the only argument.
  - If you want all of the functions except for some specific functions, you can use the except argument
  - If you just need to import a module for one function, you can place the import directive inside of the def or defp for that function.
  - erlang example:
    import :math, only: [sqrt: 1]
  - elixir example:
    import Convert

Default Values for Arguments
  - Two backslashes to indicate that there will be a default value
  ```elixir
  defmodule Fall do
    def fall(x, y \\ 50) do
      x * x * y
    end
  end

  iex> Fall.fall(5)
       1250
  iex> Fall.fall(5, 2)
       50
  ```
Documenting Code
  - You can start a comment with #

Documenting Functions
  - Documented function:
  ```elixir
  defmodule Fall do
    @doc """
    This does some math or something
    """

    @spec fall(number()) :: number()

    def fall(x, y \\ 50) do
      x * x * y
    end
  end
  ```
  - If you use h it will show you information about the function.

Documenting Modules
```elixir
defmodule Fall do

  @moduledoc """
  Here is some module documentation.
  """

  @vsn 1.0

  @doc """
  This does some math or something
  """

  @spec fall(number()) :: number()
  
  def fall(x, y \\ 50) do
    x * x * y
  end
end
```
