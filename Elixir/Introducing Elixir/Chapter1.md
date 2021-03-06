CHAPTER 1 Getting Comfortable
  - docker run -it elixir

Calling Functions
  - parenthesis optional
  - can refer to line number with v(), can use negative to refer to previous results!

Numbers in Elixir
  - Floating point, integers
  - put - in front of number to make it negative
  ```elixir
  iex> -0xcafe
       -51966
  iex> 0b01010111
       87
  iex> -0b01010111
       -87
  ```
Working with Variables in the Shell
  - Elixir, unlike many other functional programming languages, allows you assign n a new value
  ```elixir
  iex> k = 6
       6
  iex> k = k+2
       8
  ```
  - You can also put multiple statements on a line with:
  ```elixir
  iex> k = 6; m = 2
  ```
  - clear
  ```elixir
  iex> clear
  ```
