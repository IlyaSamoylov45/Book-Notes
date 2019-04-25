Chapter 2. A whirlwind tour

Chapter 2.1. Setting up your environment

Chapter 2.2. First steps
  - Meter to Foot Converter
  - defmodule defines a new module
  - def defines a new function

Chapter 2.2.2. Stopping an Elixir program
  - Ctrl-C

Chapter 2.2.3. Getting help
  - h <module> : shows a description of the module
  - h <module>. + tab : shows a list of functions available in the module
  - h <module>.<function> for more information on the function

Chapter 2.3. Data types
  - Common data types:
    - Modules, Functions, Numbers, Strings, Atoms, Tuples, Maps

Chapter 2.3.1. Modules, functions, and function clauses
  - Modules are Elixir’s way of grouping functions together.
  - Modules can be nested
  - Use dot notation to access a nested module
  - To invoke a function in elixir use:
    Module.function(arg1, arg2, ....)
    - This format is sometimes referred to as MFA (Module, Function, and Arguments)
  - You can flatten module hierarchy
  - Functions are referred to by their arity: the number of arguments they take.
  - You can define a function with the same name multiple times but they should be grouped together.

Chapter 2.3.2. Number
  - Work much like other programming languages

Chapter 2.3.3. Strings
  - Strings are binaries
  - One way to show the binary representation of a string is to use the binary concatenation operator <> to attach a null byte, <<0>>:
  - Strings aren’t char lists
    - A char list is and entirely different data type!
    - Strings are enclosed in double quotes while char list enclosed by single quotes.
    - Normally you don't use char lists but for some Erlang functions you may have to.

Chapter 2.3.4. Atoms
  - Atoms always start with a colon.
  - Atoms != Strings
  - Two ways to create atoms:
    1. :atom
    2. :"atom"
  - Atoms are important for pattern matching

Chapter 2.3.5. Tuples
  - Can contain different types of data
  - Zero-based access

Chapter 2.3.6. Maps
  - Key-value pair
    <name> = Map.new
  - <name> = Map.put(<name>, :jeff, "Erlang")
  - All data structures in Elixir are immutable, which means you can’t make any modifications to them.
  - To capture a value change you either rebind it to the same variable or you bind the value to another variable.

Chapter 2.4. Guards
  - used when you want to ensure that the arguments are a certain type
  - is_
    - for type checking

Chapter 2.5 Pattern Matching
  - Elixir uses the equals operator (=) to perform pattern matching.
  - (=) is called the match operator

Chapter 2.5.1. Using = for assigning
   - variable assignments only happen when the variable is on the left side of the match operator.

Chapter 2.5.2. Using = for matching
  - When an unsuccessful match occurs, a MatchError is raised.

Chapter 2.5.3. Destructuring
  - Destructuring allows you to bind a set of variables to a corresponding set of values anywhere that you can normally bind a value to a single variable.
  - Destructuring is useful for declaring preconditions in your programs.

Chapter 2.6. Lists
  - Somewhat similar to Linked-Lists. in that the random access is O(n)
  - A non-empty list consists of a head and a tail. The tail is also a list.
  - | is a common operator named cons (short for construct).
  - When | is applied to lists, it separates the head and tail.
  - | is another example of pattern matching.
  - | can be used to append to the beginning of a list.
  - Use ++ operator to concatenate lists

Chapter 2.7. Meet |>, the pipe operator
  - |> takes the result of the expression on the left and inserts it as the first parameter of the function call on the right.

Chapter 2.8. Erlang interoperability
  - Calling Erland code doesn't affect performance in any way!

Chapter 2.8.1. Calling Erlang functions from Elixir
  - you can’t access documentation for Erlang functions from iex
    erlang:
      1> random:uniform(123)
    elixir:
      iex> :random.uniform(123)

Chapter 2.8.2. Calling the Erlang HTTP client in Elixir
  - Elixir doesn’t come with a built-in HTTP client but Erland does.
  - Erlang has also a neat GUI front end called Observer that lets you inspect the Erlang virtual machine
    iex(1)> :observer.start
