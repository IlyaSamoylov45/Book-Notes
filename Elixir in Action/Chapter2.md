Chapter 2 Building Blocks

2.1 The interactive shell
  - Running iex starts an instance of the BEAM and then starts an interactive Elixir shell inside it.
  - Everything in Elixir is an expression that has a return value.
  - Line break indicates end of line if expression is done.
  - A more polite way to stop system in System.halt instead of Ctrl-c
  - IEx module is responsible for the shell's workings
  - Interesting:
    iex> h IEx

2.2 Working with variables
  - Elixir is a dynamic programming language, which means you don’t explicitly declare a variable or its type.
  - When you initialize a variable with a value, the variable is bound to that value
  - A variable name always starts with a lowercase alphabetic character or an underscore.
  - Naming variable convention is to use only lowercase, underscores and digits
  - Variables can end with ? and !
  - Variables are mutable, but the data they point to is immutable.

2.3 Organizing your code

2.3.1 Modules
  - A module is a collection of functions
  - A module name starts with an uppercase letter and is usually written in CamelCase style.
  - The (.) dot character us often used to organize modules hierarchically

2.3.2 Functions
  - The ? character is often used to indicate a function that returns either true or false.
  - Placing the character ! at the end of the name indicates a function that may raise a runtime error.
  - The ? and ! are conventions not rules.
  - The return value of a function is the return value of its last expression.
  - There’s no explicit return in Elixir.
  - Parentheses are optional.
  - Multiline pipelines don’t work in the shell.

2.3.3 Function arity
  - Normally a lower-arity function delegates to a higher-arity function, providing some default arguments.
  - Because arity distinguishes multiple functions of the same name, it’s not possible to have a function accept a variable number of arguments.

2.3.4 Function visibility
  - When you define a function using the def macro, the function is made public: it can be called by anyone else.
  - You can also use the defp macro to make the function private.
  - Private functions can only be used inside the module it's defined in.
  - The private function can’t be invoked outside the module.

2.3.5 Imports and aliases
  - Importing a module allows you to call its public functions without prefixing them with the module name
  - The standard library’s Kernel module is automatically imported into every module.
  - Kernel contains functions that are often used, so automatic importing makes their use easier.
  - alias: makes it possible to reference a module under a different name
    ex use of alias:
    ```elixir
    defmodule MyModule do
      alias IO, as: aliasTest
      def function3 do
        aliasTest.puts("alias called")
      end
    end
    ```
    ex2 use of alias:
    ```elixir
    defmodule MyModule do
      alias Geometry.Rectangle
      def my_function do
        Rectangle.area(...)
      end
    end
    ```
2.3.6 Module attributes
  - Purpose of module attributes
    1. can be used as compile-time constants
    2. you can register any attribute, which can then be queried in runtime
  - An attribute can be registered, which means it will be stored in the generated binary and can be accessed at runtime.
  - @spec, @moduledoc and @doc are good for documentation.
  - @spec ex:
      @spec insert_at(list, integer, any) :: list
      - gives list and inserts any value into index integer then returns a list

2.3.7 Comments
  - Hashtag : #
  - no block comments.

2.4 Understanding the type system

2.4.1 Numbers
  - The division operator / always returns a float value
  - To do integer division or calculate remainder use auto-imported Kernel function
    ```elixir
    rem(3, 2) = 1
    div(5, 2) = 2
    ```
  - INTERESTING: You can use the underscore character as a visual delimiter:
  ```elixir
    iex> 1_000
    1000
  ```

2.4.2 Atoms
  - Atoms are literal named constants
    :atom
  - Atom start with a colon character, followed by a combination of alphanumerics and/or underscore characters
  - possible to use spaces
    :"This doesnt seem like a good idea"
  - atoms are best used for named constants.
  - atoms :false and :true are used instead of a Boolean type
  - Boolean is just an atom that has a value of true or false.
  - another atom is nil
  - The operator || returns the first expression that isn't falsy
  - The operator && returns the second expression, but only if the first expression is truthy.
  - Short-circuiting can be used for elegant operation chaining.
    ex:
      read_cached || read_from_disk || read_from_database

2.4.3 Tuples
  - To extract an element from the tuple, you can use the Kernel.elem/2 function which accepts a tuple and and a zero-based index
    ex:
    ```elixir
      iex> test = {"book", 300}
           {"book", 300}
      iex> pages = elem(test, 1)
           300
      iex> pages = put_elem(test, 1, 400)
          {"book", 400}
    ```
  - Tuples are most appropriate for grouping a small, fixed number of elements together

2.4.4 Lists
  - Dynamic, variable-sized collections of data
  - Most of the operations on lists have an O(n) complexity
  - To get an element of a list, you can use the Enum.at/2 function
  - You can insert a new element at the specified position with the List.insert_at function,  you can use a negative value for the insert position
  - In general, you should avoid adding elements to the end of a list.
  - Lists are most efficient when new elements are pushed to the top, or popped from it.
  - List is a pair of two values: head and tail.
  - Remember that internally, lists are recursive structures of (head, tail) pairs.
  - hd function for head, tl function for tail.
    ```elixir
    iex> hd([1, 2])
         1
    iex> tl([1, 2])
         2
    ```
  - Both hd and tl take O(1)

2.4.5 Immutability
  - Every function returns the new, modified version of the input data.
  - The result resides in another memory location.
  - The modification of the input will result in some data copying, but generally, most of the memory will be shared between the old and the new version.

2.4.6 Maps   