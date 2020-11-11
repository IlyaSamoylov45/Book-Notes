Chapter 3 Control Flow
  - Classical conditional constructs such as if and case are often replaced with multiclause functions, and there are no classical loop statements such as while.

Chapter 3.1 Pattern matching
  - When you write a = 1, variable a is bound to the value 1, and = operator isn't assignment.
  - = is called the match operator and is an example of pattern matching.
  - Pattern matching allows you to write elegant, declarative-like conditionals and loops.

Chapter 3.1.1 The match operator
  - A variable always matches the right-side term, and it becomes bound to the value of that term.

Chapter 3.1.2 Matching tuples
  ```elixir
  iex(1)> {name, age} = {"Bob", 25}
  iex(2)> name
          "Bob"
  iex(3)> age
          25
  ```
  - This feature is useful when you call a function that returns a tuple and you want to bind individual elements of that tuple to separate variables.
  ```elixir
  iex(1)> {date, time} = :calendar.local_time()
  iex(2)> {year, month, day} = date
  iex(3)> {hour, minute, second} = time
  ```

Chapter 3.1.3 Matching constants
  - = is not an assignment operator.
  ```elixir
  iex(1)> person = {:person, "Bob", 25}
  iex(2)> {:person, name, age} = person
  {:person, "Bob", 25}
  iex(3)> name
  "Bob"
  ```
  - The first element is a constant atom :person, later you can rely on this knowledge and retrieve individual attributes of the person.
  - Many functions from Elixir and Erlang return either {:ok, result} or {:error, reason}.
  ```elixir
  {:ok, contents} = File.read("my_app.config")
  ```
  - In above three things happen:
    1. An attempt to open and read the file my_app.config
    2. If the attempt succeeds, the file contents are extracted to the variable contents.
    3. If the attempt fails, an error is raised. This happens because the result of File.read is a tuple in the form {:error, reason}, so the match to {:ok, contents} fails.

Chapter 3.1.4 Variables in patterns
  - anonymous variable : ( _ )
  ```elixir
  iex(1)> {_, time} = :calendar.local_time()
  ```
  - Anonymous variable works just like a named variable: it matches any right-side term. But it isn't bound to any variable.
  - Descriptive name after the underscore character:
  ```Elixir
  iex(1)> {_date, time} = :calendar.local_time()
  ```
  - Patterns can be arbitrarily nested.
  ```elixir
  iex(1)> {_, {hour, _, _}} = :calendar.local_time()
  iex(2)> hour
  20
  ```
  - Variable can be referenced multiple times
  ```elixir
  iex(1)> {amount, amount, amount} = {127, 127, 127}          
  {127, 127, 127}
  iex(2)> {amount, amount, amount} = {127, 127, 1}
  ** (MatchError) no match of right hand side value: {127, 127, 1}
  ```
  - pin operator (^) says that you expect the value of the variable ^name to be in the appropriate position in the right-side term.
  ```elixir
  iex(1)> expected_name = "Bob"                     
  "Bob"
  iex(2)> {^expected_name, _} = {"Bob", 25}         
  {"Bob", 25}
  iex(3)> {^expected_name, _} = {"Alice", 30}       
  ** (MatchError) no match of right hand side value: {"Alice", 30}
  ```
  - Above example is same as using the hard-coded pattern {"Bob", _ }.
  - IMPORTANT: the pin operator doesn’t bind the variable. You expect that the variable is already bound meaning that it has a value — and you try to match against that value.

Chapter 3.1.5 Matching lists
  - Tuple techniques work for lists as well
  ```elixir
  iex(1)> [first, second, third] = [1, 2, 3] \[1, 2, 3]
  ```
  - Matching lists is more often done by relying on their recursive nature.
  - Ineffective way to find min value:
  ```elixir
  iex(1)> [min | _] = Enum.sort([3,2,1])
  iex(2)> min
  1
  ```

Chapter 3.1.6 Matching maps
  - To match map use this syntax:
  ```elixir
  iex(1)> %{name: name, age: age} = %{name: "Bob", age: 25}
  %{age: 25, name: "Bob"}
  iex(2)> name
  "Bob"
  ```
  - When matching a map, the left-side pattern doesn’t need to contain all the keys from the right-side term:
  ```elixir
  iex(1)> %{age: age} =  %{name: "Bob", age: 25}
  iex(2)> age
  25
  ```
  - A match will fail if the pattern contains a key that’s not in the matched term

Chapter 3.1.7 Matching bitstrings and binaries
  - bitstring is a chunk of bits, and a binary is a special case of a bitstring that's always aligned to the byte size.
  - To match binary:
  ```elixir
  iex(1)> binary = <<1, 2, 3>>
  <<1, 2, 3>>
  iex(2)> <<b1, b2, b3>> = binary    
  <<1, 2, 3>>
  iex(3)> b2
  2
  ```
  - rest::binary states that you expect an arbitrary-sized binary.
  ```elixir
  iex(1)> <<b1, rest :: binary>> = binary
  <<1, 2, 3>>
  iex(2)> b1
  1
  iex(3)> rest
  <<2, 3>>
  ```
  -  You can even extract separate bits or groups of bits. Because the number 155 is in binary represented as 10011011, you get values of 9 (1001 binary) and 11 (1011 binary).
  ```elixir
  iex(1)> <<a :: 4, b :: 4>> = << 155 >>
  << 155 >>
  iex(2)> a
  9
  iex(3)> b
  11
  ```
  - Matching bitstrings and binaries is immensely useful when you’re trying to parse packed binary content that comes from a file, an external device, or a network. In such situations, you can use binary matching to extract separate bits and bytes elegantly.
  - Strings are binaries, so you can use binary matches to extract individual bits and bytes from a string
  ```elixir
  iex(1)> <<b1, b2, b3>> = "ABC"
  "ABC"
  iex(2)> b1
  65
  iex(3)> b3
  67
  ```
  - Above isn’t very useful, especially if you’re dealing with Unicode strings.
  - Extracting individual characters is better done using functions from the String module.
  - A more useful pattern is to match the beginning of the string:
  ```elixir
  iex(1)> command = "ping www.example.com"
  "ping www.example.com"
  iex(2)> "ping " <> url = command          
  "ping www.example.com"
  iex(3)> url
  "www.example.com"
  ```
  - When you write "ping " <> url = command, you state the expectation that a command variable is a binary string starting with "ping ". If this matches, the rest of the string is bound to the variable url.

Chapter 3.1.8 Compound matches
  - A match expression has this general form: ```pattern = expression```
  ```elixir
  iex(1)> a = 1 + 3 4
  ```
  - Break Down:
    1. The expression on the right side is evaluated.
    2. The resulting value is matched against the left-side pattern.
    3. Variables from the pattern are bound.
    4. The result of the match expression is the result of the right-side term.
  - Match expressions can be chained:
  ```elixir
  iex(1)> a = (b = 1 + 3)
  4
  ```
  - Break Down : Both a and b have the value 4.
    1. The expression 1 + 3 is evaluated.
    2. The result (4) is matched against the pattern b.
    3. The result of the inner match (which is again 4) is matched against the pattern a.
  - Parentheses are optional
  ```Elixir
  iex(1)> a = b = 1 + 3 4
  ```
  - Operator = is right-associative.
  - Practical example: Let’s say you want to retrieve the function’s total result (datetime) as well as the current hour of the day.
  ```elixir
  iex(1)> date_time = {_, {hour, _, _}} = :calendar.local_time()
  iex(2)> date_time
  {{2018, 11, 11}, {21, 32, 34}}
  iex(3)> hour
  21
  ```

Chapter 3.1.9 General behavior
  - The pattern-matching expression consists of two parts:
    - pattern (left side)
    - term (right side).
  - In a pattern-matching expression, you perform two different tasks:
    - You assert your expectations about the right-side term. If these expectations aren’t met, an error is raised
    - You bind some parts of the term to variables from the pattern.

Chapter 3.2 Matching with functions
  - Pattern-matching function arguments :
  ```elixir
  defmodule Rectangle do  
    def area({a, b}) do               
      a * b  
    end
  end

  iex(1)> Rectangle.area({2, 3})
  6
  ```
  - When calling functions, the term being matched is the argument provided to the function call.

Chapter 3.2.1 Multiclause functions
  - Elixir allows you to overload a function by specifying multiple clauses.
  - A clause is a function definition specified by the def construct.
  ```elixir
  defmodule Geometry do  
    def area({:rectangle, a, b}) do         
      a * b  
    end
    def area({:square, a}) do               
      a * a  
    end
    def area({:circle, r}) do               
      r * r * 3.14  
    end
  end
  ```
  ```elixir
  iex(1)> Geometry.area({:square, 5})
  25
  ```
  - Depending on which argument you pass, the appropriate clause is called.
  - The first clause that successfully matches all arguments is executed.
  - It’s important to be aware that from the caller’s perspective, a multiclause function is a single function.
  - To create a function value with the capture operator, &: ``` &Module.function/arity ```
  - If you capture Geometry.area/1, you capture all of its clauses:
  ```elixir
  iex(1)> fun = &Geometry.area/1
  iex(2)> fun.({:circle, 4})
  50.24
  ```
  ```elixir
  defmodule Geometry do  
    def area({:rectangle, a, b}) do   
      a * b
    end
    def area({:square, a}) do    
      a * a  
    end
    def area({:circle, r}) do    
      r * r * 3.14  
    end
    def area(unknown) do                       
      {:error, {:unknown_shape, unknown}}  
    end
  end

  iex(1)> Geometry.area({:triangle, 1, 2, 3})
  {:error, {:unknown_shape, {:triangle, 1, 2, 3}}}
  ```
  - Above works because a variable pattern always matches the corresponding term.
  - Functions differ in name and arity.
  - Functions with the same name but different arities are in reality two different functions.
  - You should always group clauses of the same function together, instead of scattering them in various places in the module.

Chapter 3.2.2 Guards
  - Guards are an extension of the basic pattern-matching mechanism.
  - Guards allow you to state additional broader expectations that must be satisfied for the entire pattern to match.
  - Specified by providing the when clause after the arguments list.
  ```elixir
  defmodule TestNum do  
    def test(x) when x < 0 do    
      :negative  
    end
    def test(0), do: :zero
    def test(x) when x > 0 do    
      :positive  
    end
  end
  ```
  - Calling this function with a non-number yields strange results:
  ```elixir
  iex(1)> TestNum.test(:not_a_number)
  :positive
  ```
  - This is because Elixir terms can be compared with the operators < and >, even if they’re not of the same type.
  - number < atom < reference < fun < port < pid <  tuple < map < list < bitstring (binary)
  - Due to reasoning above, a number is smaller than any other type, which is why TestNum.test/1 always returns :positive if you provide a non-number.
  - Fix:
  ```elixir
  defmodule TestNum do  
    def test(x) when is_number(x) and x < 0 do    
      :negative  
    end
    def test(0), do: :zero
    def test(x) when is_number(x) and x > 0 do    
      :positive  
    end
  end
  ```
  - This fixes it and will result in an error in the event of a non-number
  - Operators and functions allowed in guards:
    -	Comparison operators (==, !=, ===, !==, >, <, <=, >=)
    - Boolean operators (and, or) and negation operators (not, !)
    -	Arithmetic operators (+ , - , * , / )
    - Type-check functions from the Kernel module (for example, is_number/1, is_ atom/1, and so on)

Chapter 3.2.3 Multiclause lambdas
  - Anonymous functions (lambdas) may also consist of multiple clauses.
  ```elixir
  iex(1)> double = fn x -> x*2 end            
  iex(2)> double.(3)                          
  6
  ```
  - Example of function that inspects whether a number is positive, negative, or zero:
  ```elixir
  iex(3)> test_num =
                    fn            
                      x when is_number(x) and x < 0 ->              
                        :negative
                      0 ->
                        :zero
                      x when is_number(x) and x > 0 ->              
                        :positive          
                    end
  ```
  - General form for multiclause lambda:
  ```elixir
  fn  pattern_1, pattern_2 ->    
      ...                   
      pattern_3, pattern_4 ->    
        ...                   
      ...
  end
  ```

Chapter 3.3 Conditionals
  - Conditional branching, with constructs such as if and case.
  - Multiclause functions can be used for this purpose as well.

Chapter 3.3.1 Branching with multiclause functions
  - In a typical imperative language like JavaScript you would write an if else statement but you can use conditional logic with multiclause functions.
  ```Elixir
  defmodule TestNum do  
    def test(x) when x < 0, do: :negative  
    def test(0), do: :zero  
    def test(x), do: :positive
  end
  ```
  ```JavaScript
  function test(x){  
    if (x < 0) return "negative";  
    if (x == 0) return "zero";  
    return "positive";
  }
  ```
  - By relying on pattern matching, you can implement polymorphic functions that do different things depending on the input type:
  ```elixir
  iex(1)> defmodule Polymorphic do          
            def double(x) when is_number(x), do: 2 * x          
            def double(x) when is_binary(x), do: x <> x        
          end
  ```
  - It really shows in recursions
  - A multiclause-powered recursion is also used as a for looping.
  - Everything that can be done with multiclause can be done with branching constructs

Chapter 3.3.2 Classical branching constructs
  - macros if, unless, cond, and case are provided for classical branching.
  - if and unless:
  ```elixir
  if condition do  
    ...
  else  
    ...
  end
  ```
  - You can also condense this into a one-liner, much like a
  ```elixir
  def construct: if condition, do: something, else: another_thing
  ```
  - If the condition isn’t met and the else clause isn’t specified, the return value is the atom nil
  - Everything in Elixir is an expression that has a return value.
  - unless macro is equal to if (not …):
  ```elixir
  def max(a, b) do  
    unless a >= b, do: b, else: a
  end
  ```
  - The cond macro can be thought of as equivalent to an if-else-if pattern.
  - If none of the conditions is satisfied, cond raises an error.
  ```elixir
  def max(a, b) do
    cond do
      a >= b -> a
      true -> b
    end
  end
  ```
  - The true pattern ensures that the condition will always be satisfied. If nothing satisfies it before then it is executed.
  - General cond form:
  ```elixir
  cond do  
    expression_1 ->    
    ...
    expression_2 ->    
    ...
  ...
  end
  ```
  - General case form:
  ```elixir
  case expression do  
    pattern_1 ->    
      ...
    pattern_2 ->    
      ...
    ...
    _ -> ...
  end
  ```
  - Case deals with pattern matching. The first one that matches is executed, and the result of the corresponding block is the result of the entire case expression.
  - If no clause matches, an error is raised.
  ```Elixir
  def max(a,b) do  
    case a >= b do    
      true -> a    
      false -> b  
    end
  end
  ```
  - The case construct is most suitable if you don’t want to define a separate multiclause function.

Chapter 3.3.3 The with special form
  - The with special form allows you to use pattern matching to chain multiple expressions, verify that the result of each conforms to the desired pattern, and return the first unexpected result.
  ```elixir
  with pattern_1 <- expression_1,     
       pattern_2 <- expression_2,     
       ...
  do  
    ...
  end
  ```
  - You start from the top, evaluating the first expression and matching the result against the corresponding pattern. If the match succeeds, you move to the next expression.
  - If any match fails, however, with will not proceed to evaluate subsequent expressions.
  ```elixir
  iex(1)> with {:ok, login} <- {:ok, "alice"},             
               {:ok, email} <- {:ok, "some_email"} do
               %{login: login, email: email}        
          end

  %{email: "some_email", login: "alice"}
  ```

Chapter 3.4 Loops and iterations

Chapter 3.4.1 Iterating with recursion
  -  A very deep recursion might lead to a stack overflow and crash the entire program. This isn’t necessarily a problem in Elixir, because of the tail-call optimization.

Chapter 3.4.2 Tail function calls
  - If the last thing a function does is call another function (or itself), you’re dealing with a tail call
  - Elixir (or, more precisely, Erlang) performs tail-call optimization with tail calls.
  - You don’t allocate additional stack space before calling the function, which in turn means the tail function call consumes no additional memory.
  - Because tail recursion doesn’t consume additional memory, it’s an appropriate solution for arbitrarily large iterations.
  - You can think of tail recursion as a direct equivalent of a classical loop in imperative languages.
  - Example:
  ```Elixir
  def fun(...) do  
    ...  
    if something do   
       ...    
       another_fun(...)       
     end
   end
  ```
  - Not tail recursion:
  ```Elixir
  def fun(...) do  
    1 + another_fun(...)    
  end
  ```

Chapter 3.4.3 Higher-order functions
  - A higher-order function is a fancy name for a function that takes one or more functions as its input or returns one or more functions (or both).
  - Example :
  ```Elixir
  iex(1)> Enum.each(          
                    [1, 2, 3],          
                    fn x -> IO.puts(x) end                 
                    )
  1
  2
  3
  ```
  - Example:
  ```Elixir
  iex(1)> Enum.map(          
            [1, 2, 3],          
            &(2 * &1)        
          )
  ```
  - The &(…) denotes a simplified lambda definition, where you use &n as a placeholder for the nth argument of the lambda.

Chapter 3.4.4 Comprehensions
  - Comprehensions can return anything that’s collectable.
  - Collectable is an abstract term for a functional data type that can collect values.
  ```Elixir
  iex(1)> multiplication_table =          
            for x <- 1..9, y <- 1..9,
                x <= y,               
                into: %{} do                             
              {{x, y}, x*y}          
            end
  iex(2)> multiplication_table[{7, 6}]
  42
  ```

Chapter 3.4.5 Streams
  - In the shell, you have to place the pipeline on the same line as the preceding expression
  - Streams are implemented in the Stream module which at first glance looks similar to the Enum module
  - A stream is a lazy enumerable, which means it produces the actual result on demand.
  ```Elixir
  iex(1)> stream = [1, 2, 3] |>                                   
            Stream.map(fn x -> 2 * x end)
  #Stream<[enum: [1, 2, 3],                               
      funs: [#Function<44.45151713/1 in Stream.map/2>]]>
  iex(2)> Enum.to_list(stream)
  [2, 4, 6]
  ```
  - Because a stream is a lazy enumerable, the iteration over the input list ([1, 2, 3]) and the corresponding transformation (multiplication by 2) haven’t yet happened. Instead, you get the structure that describes the computation.
  - Values are produced one by one when Enum.to_list requests another element.
  - You can use Enum.take/2 to request only one element from the stream:
  ```Elixir
  iex(3)> Enum.take(stream, 1)
  [2]
  ```
  ```elixir
  iex(1)> [9, -1, "foo", 25, 49]                                    |>        
          Stream.filter(&(is_number(&1) and &1 > 0))                |>        
          Stream.map(&{&1, :math.sqrt(&1)})                         |>        Stream.with_index                                         |>        
          Enum.each(            
            fn {{input, result}, index} ->              
              IO.puts("#{index + 1}. sqrt(#{input}) = #{result}")
            end          
            )
  1. sqrt(9) = 3.0
  2. sqrt(25) = 5.0
  3. sqrt(49) = 7.0
  ```
  - A typical case is when you need to parse each line of a file. Relying on eager Enum functions means you have to read the entire file into memory and then iterate through each line. In contrast, using streams makes it possible to read and immediately parse one line at a time.

Summary
  - Tail recursion is used when you need to run an arbitrarily long loop.
