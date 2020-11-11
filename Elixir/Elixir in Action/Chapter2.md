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
  - They’re used to power dynamically sized key/value structures, but they’re also used to manage simple records
  - Dynamically sized maps

  ```elixir
  iex(1)> empty_map = %{} # Create empty map
  iex(2)> squares = %{1 => 1, 2 => 4} # Create map with some values
  iex(3)> squares = Map.new([{1, 1}, {2, 4}, {3, 9}]) # Populate with Map.new function
          %{1 => 1, 2 => 4, 3 => 9}
  iex(4)> squares[2] # Fetch value given key
          4
  iex(5)> squares[4]
          nil
  iex(6)> Map.get(squares, 2) # Map.get/3 allows you to specify the default value to return if key not found if no default specified then nil returned
          4
  iex(7)> Map.get(squares, 4)
          nil
  iex(8)> Map.get(squares, 4, :not_found)
          :not_found
  iex(13)> squares = Map.put(squares, 4, 16)
           %{1 => 1, 2 => 4, 3 => 9, 4 => 16}
  ```

  - Structured Data

  ```elixir
  iex(1)> bob = %{:name => "Bob", :age => 25, :works_at => "Initech"}
  iex(2)> bob = %{name: "Bob", age: 25, works_at: "Initech"}
  iex(3)> bob[:works_at]
          "Initech" # Very Cool
  iex(4)> bob[:non_existent_field]
          nil
  iex(5)> bob.age # Atom keys again receive special syntax treatment.
          25  
  iex(7)> next_years_bob = %{bob | age: 26} # Change value in field.
          %{age: 26, name: "Bob", works_at: "Initech"}
  iex(8)> %{bob | age: 26, works_at: "Initrode"} # Can be used to change multiple fields.
          %{age: 26, name: "Bob", works_at: "Initrode"}
  ```

2.4.7 Binaries and bitstrings
  -  You can create binaries by enclosing the byte sequence between << and >> operators.
  - The most important thing you need to know about binaries is that they’re consecutive sequences of bytes.
  -  If you provide a byte value bigger than 255, it’s truncated to the byte size:

  ```Elixir
  iex(2)> <<256>>
          <<0>>
  iex(3)> <<257>>
          <<1>>
  iex(4)> <<512>>
          <<0>>
  ```

  - You can specify the size of each value and thus tell the compiler how many bits to use for that particular value:

  ```Elixir
  iex(5)> <<257::16>>
          <<1, 1>>
  iex(6)> <<1::4, 15::4>>
          <<31>>
  iex(8)> <<1, 2>> <> <<3, 4>> # concatenate two binaries or bitstrings
          <<1, 2, 3, 4>>  
  ```

2.4.8 Strings
  - Elixir doesn’t have a dedicated string type.
  - Elixir provides support for embedded string expressions. You can use #{} to place an Elixir expression in a string constant.
  - The expression is immediately evaluated, and its string representation is placed at the corresponding location in the string

  ```Elixir
  iex(1)> "This is a string"
  "This is a string"
  iex(2)> "Embedded expression: #{3 + 0.14}"
  "Embedded expression: 3.14"
  iex(4)> "        
          This is        
          a multiline string        
          "
  iex(5)> ~s(This is also a string) # sigils
  "This is also a string"
  iex(6)> ~s("Do... or do not. There is no try." -Master Yoda) # can be useful if you want to include quotes in a string
  "\"Do... or do not. There is no try.\" -Master Yoda"
  ```
  - Sigils can be useful if you want to include quotes in a string
  - Uppercase ~S sigil does not allow interpolation so it comes out how it is written.
  - Since strings are binaries, you can concatenate them with the <> operator
  - Heredoc support better formatting for multiline string and are written with 3 """ and end with 3 """.
  - Alternative way to represent strings is with character lists which use single quotes.
  - A character list is a list of ints that represent a single character.
  - When a list consists of integers that represent printable characters, it’s printed to the screen in the string form.
  - Even at runtime it doesn't distinguish between a list of integers and a character list.
  - Character lists not compatible with binary strings so most operations from String module wont work with character lists.
  - You should prefer strings over character lists but sometimes certain functions only work with character lists. This is mostly due to Erlang libraries.
  - You can convert binary string to character list with String.to_charlist/1 function.
  - To convert character list to binary string use List.to_string()

2.4.9 First-class functions
  - To create a function variable, you can use the fn construct:

  ```Elixir
  iex(1)> square = fn x ->          
            x * x        
          end
  ```

  - Because the function isn’t bound to a global name, it’s also called an anonymous function or a lambda.
  - You can call this function by specifying the variable name followed by a dot (.) and the arguments

  ```Elixir
  iex(2)> square.(4)
          16
  ```

  - Without the dot operator, you’d have to parse the surrounding code to understand whether you’re calling a named or an anonymous function.
  - Instead of writing fn x → IO.puts(x) end, you can write &IO.puts/1.
  - The & operator, also known as the capture operator, takes the full function qualifier —
 a module name, a function name, and an arity — and turns that function into a lambda that can be assigned to a variable

 ```Elixir
 iex(7)> lambda = fn x, y, z -> x * y + z end
 iex(8)> lambda = &(&1 * &2 + &3)
 iex(9)> lambda.(2, 3, 4)
 ```

 - A lambda can reference any variable outside the scope.
 - This is also known as closure: by holding a reference to a lambda, you indirectly hold a reference to all variables it uses, even if those variables are from the external scope.
 - A closure always captures a specific memory location.
 - Rebinding a variable doesn’t affect the previously defined lambda that references the same symbolic name

2.4.10 Other built-in types
  - A reference is an almost unique piece of information in a BEAM instance.
  - A pid (process identifier) is used to identify an Erlang process
  - The port identifier is important when using ports.
    - File I/O and communication with external programs are done through ports.

2.4.11 Higher-level types
  - Range:
    - A range is an abstraction that allows you to represent a range of numbers
    - Ranges are enumerable, so functions from the Enum module know how to work with them.
    - Internally a range is not a special type but a map that contains range boundries.
    - A range has special syntax:

    ```elixir
    iex(1)> range = 5..10
    iex(2)> 2 in range
    false
    iex(3)> 5 in range
    true
    ```

  - Keyword Lists:
    - A keyword list is a special case of a list, where each element is a two-element tuple, and the first element of each tuple is an atom and second element is any type.
    - Lookup complexity is O(n)
    - A keyword list can contain multiple values for the same key.
    - Unlike with maps, you can control the ordering of keyword list elements
    ```elixir
    iex(1)> days = [{:m, 1}, {:w, 3}]
    #Another way
    iex(2)> days = [m: 1, w: 3]
    iex(3)> Keyword.get(days, :w)
    3
    # Just as with maps, you can use the operator [] to fetch a value:
    iex(4)> days[:m]
    1
    iex(5)> IO.inspect([100, 200, 300], width: 3, limit: 1)
    [100,
    ...]
    [100, 200, 300]
    iex(6)> IO.inspect([100, 200, 300], width: 3)
    [100,
    200,
    300]
    [100, 200, 300]
    ```

  - Mapset
    - A MapSet is the implementation of a set
    - A MapSet is also an enumerable
    - Does not preserve ordering of items

    ```Elixir
    iex(1)> cars = MapSet.new([:toyota, :BMW, :Ford])
    #MapSet<[:BMW, :Ford, :toyota]>
    iex(2)> MapSet.member?(cars, :BMW)
    true
    iex(3)> MapSet.member?(cars, :boop)
    false
    iex(3)> MapSet.put(cars, :Chevy)
    #MapSet<[:BMW, :Chevy, :Ford, :toyota]>
    ```

  - Times and Dates
    - There are a couple modules for working with date and time types: Date, Time, DateTime, and NaiveDateTime
    - Can be created with the ~D sigil
    - You can represent a time with the ~T sigil
    - Combination of both with ~N sigil
    - The DateTime module can be used to work with datetimes in some timezone. Unlike with other types, no sigil is available

    ```elixir
    iex(1)> naive_datetime = ~N[2018-01-31 11:59:12.000007]
    iex(2)> datetime = DateTime.from_naive!(naive_datetime, "Etc/UTC")
    iex(3)> datetime.year
    2019
    iex(4)> datetime.time_zone
    "Etc/UTC"
    ```

2.4.12 IO Lists
  - An IO list is a special sort of list that’s useful for incrementally building output that will be forwarded to an I/O device
  - Each element of an IO list must be one of the following:
    - An integer in the range of 0 to 255
    - A binary
    - An IO list
  - IO lists are useful when you need to incrementally build a stream of bytes.
  - Lists usually aren’t good in this case, because appending to a list is an O(n) operation.
  - Appending to an IO list is O(1), because you can use nesting.

2.5 Operators
  - The only thing we need to discuss here is the difference between strict and weak equality. This is relevant only when comparing integers to floats:

  ```Elixir
  iex(1)> 1 == 1.0           
  true
  iex(2)> 1 === 1.0          
  false
  ```

  - The && operator returns the second expression only if the first one isn’t falsy.
  - The || operator returns the first expression if it’s truthy
  - IMPORTANT: Many operators in Elixir are actually functions:
    - For example, instead of calling a+b , you can call Kernel.+(a,b).
    - Instead of Kernel.+(a,b) we can call anonymous function &Kernel.+/2 or even better &+/2
  ```elixir
  iex(1)> test = &+/2
  &:erlang.+/2
  iex(2)> test.(4, 3)
  7
  ```

2.6 Macros
  - A macro consists of Elixir code that can change the semantics of the input code.
  - A macro is always called at compile time; it receives the parsed representation of the input Elixir code, and it has the opportunity to return an alternative version of that code.
  - For example:

  ```elixir
  unless some_expression do  
    block_1
  else  
    block_2
  end
  ```

  - unless isn’t a special keyword. It’s a macro (meaning an Elixir function) that transforms the input code into something like this:

  ```elixir
  if some_expression do  
    block_2
  else  
    block_1
  end
  ```

  - Many parts of Elixir are written in Elixir with the help of macros.
  - Some macros include: unless and if constructs, defmodule and def.
  - Whereas other languages usually use keywords for such features, in Elixir they’re built on top of a much smaller language core.

2.7 Understanding the runtime
  - The Elixir runtime is a BEAM instance meaning that once the compiling is done and the system is started, Erlang takes control.

2.7.1 Modules and functions in the runtime
  - The VM keeps track of all modules loaded in memory. When you call a function from a module, BEAM first checks whether the module is loaded.
  - When you compile the source containing the Geometry module, the file generated on the disk is named Elixir.Geometry.beam, regardless of the name of the input source file.
  - In Erlang, modules also correspond to atoms. Somewhere on the disk is a file named code.beam that contains the compiled code of the :code module.
  - When you start BEAM with Elixir tools (such as iex), some code paths are predefined for you. You can add additional code paths by providing the -pa switch.
  - Elixir modules are nothing more than Erlang modules with fancier names
  - REMEMBER: At runtime Module names are atoms.

2.7.2 Starting the runtime
  - Ways to start BEAM other than iex
    1. Interactive shell
      - When you start the shell, the BEAM instance is started underneath, and the Elixir shell takes control.
      - The shell takes the input, interprets it, and prints the result.
    2. Running scripts
      - $ elixir my_source.ex
      - Actions that take place:
        1. The BEAM instance is started.
        2. The file my_source.ex is compiled in memory, and the resulting modules are loaded to the VM. No .beam file is generated on the disk.
        3. Whatever code resides outside of a module is interpreted.
        4. Once everything is finished, BEAM is stopped.
      - If you don’t want a BEAM instance to terminate, you can provide the --no-halt parameter: $ elixir --no-halt script.exs
    3. The Mix Tool
      - The mix tool is used to manage projects that are made up of multiple source files.
      - $ mix new project_name
      - You can change to the project_name folder and compile the entire project
        - $ cd my_project
        - $ mix compile
      - The compilation goes through all the files from the lib folder and places the resulting .beam files in the ebin folder.
