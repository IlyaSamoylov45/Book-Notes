Chapter 6 Lists

List Basics
  - An Elixir list is an ordered set of elements.
  - You can pattern match with lists just as you can with other Elixir data structures:

  ``` Elixir
  iex(1)> [1,x,4,y] = [1,2,4,8]
  [1,2,4,8]
  iex(2)> x
  2
  iex(3)> y
  8
  ```

  - To create a single list from multiple lists, you can use the Enum.concat/2 function or the equivalent ++ operator
  - If you have a set of lists you’d like combined, you can use the Enum.concat/1 function, which takes a list of lists as its argument and returns a single list containing their contents:

  ``` Elixir
  iex(12)> c = [64,128,256]
  [64,128,256]
  iex(13)> combined3 = Enum.concat([a,b,c])
  [1,2,4,8,16,32,64,128,256]
  ```

Splitting Lists into Heads and Tails
  - The two variables separated by a vertical bar (|), or cons, for list constructor, will be bound to the head and tail of the list on the right.
  ``` Elixir
  iex(1)> list = [1, 2, 4]
  [1,2,4]
  iex(2)> [h1 | t1] = list
  [1,2,4]
  iex(3)> h1
  1
  iex(4)> t1
  [2,4]
  ```

Mixing Lists and Tuples
  - The simplest tools are the List.zip/1 and List.unzip/1 functions. They can turn two lists of the same size into a list of tuples or a list of tuples into a list of two lists:
  ```Elixir
  iex(1)> list1 = [:earth, :moon, :mars]
  [:earth,:moon,:mars]
  iex(2)> list2 = [9.8, 1.6, 3.71]
  [9.8,1.6,3.71]
  iex(3)> planemos = List.zip([list1, list2])
  [earth: 9.8, moon: 1.6, mars: 3.71]
  iex(4)> separate_lists = List.unzip(planemos)
  [[:earth,:moon,:mars],[9.8,1.6,3.71]]
  ```

IMPORTANT: List.unzip no longer works. Use Enum.unzip()
