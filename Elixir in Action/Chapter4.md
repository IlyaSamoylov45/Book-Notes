Chapter 4 Data abstractions
  - In Elixir, higher-level abstractions( such as Money, Date, Employee, and OrderItem) are implemented with pure, stateless modules.
  - In a typical OO language, the basic abstraction building blocks are classes and objects.
  - Instead of classes, you use modules, which are collections of functions.
  - Instead of calling methods on objects, you explicitly call module functions and provide input data via arguments.
  - Another big difference from OO languages is that data is immutable.
  - String and List are examples of modules that are dedicated to a specific data type.
  - "modifier functions" (the ones that transform the data) return data of the same type.
  - The basic principles of data abstraction in Elixir can be summarized as follows:
    - A module is in charge of abstracting some data.
    - The module’s functions usually expect an instance of the data abstraction as the first argument.
    - Modifier functions return a modified version of the abstraction.
    - Query functions return some other type of data.

Chapter 4.1 Abstracting with modules
  - MapSet is implemented in pure Elixir and can serve as a good template for how to design an abstraction in Elixir.
  ```elixir
  iex(1)> days =         
                MapSet.new() |>                              
                MapSet.put(:monday) |>                     
                MapSet.put(:tuesday)           
  iex(2)> MapSet.member?(days, :monday)      
  true
  ```
  - Notice the new/0 function that creates an empty instance of the abstraction.

Chapter 4.1.1 Basic abstraction
  - You’ll use dates as keys, with values being lists of entries for given dates.
  ```Elixir
  defmodule TodoList do  
    def new(), do: %{}  
    ...
  end
  ```
  - This function expects a to-do list (which you know is a map) and has to add the entry to the list under a given key (date):
  ```Elixir
  defmodule TodoList do  
    ...  
    def add_entry(todo_list, date, title) do    
      Map.update(      
                  todo_list,      
                  date,      
                  [title],
                  fn titles -> [title | titles] end          
                 )  
    end  
    ...
  end
  ```
  - The Map.update/4 function receives a map, a key, an initial value, and an updater lambda.
  - The lambda receives the existing value and returns the new value for that key.
  - entries/2 function returns all entries for a given date, or an empty list if no task exists for that date
  ```Elixir
  defmodule TodoList do  
    ...  
    def entries(todo_list, date) do    
        Map.get(todo_list, date, [])  
    end
  end
  ```
  - The third argument to Map.get/3 is a default value that’s returned if a given key isn’t present in the map.

Chapter 4.1.2 Composing abstractions
  - Nothing stops you from creating one abstraction on top of another.
  ```Elixir
  defmodule MultiDict do  
    def new(), do: %{}

    def add(dict, key, value) do    
      Map.update(dict, key, [value], &[value | &1])  
    end

    def get(dict, key) do    
      Map.get(dict, key, [])  
    end
  end
  ```
  - Now TodoList relys on a MultiDict
  ```Elixir
  defmodule TodoList do  
    def new(), do: MultiDict.new()

    def add_entry(todo_list, date, title) do    
      MultiDict.add(todo_list, date, title)  
    end

    def entries(todo_list, date) do    
      MultiDict.get(todo_list, date)  
    end
  end
  ```
  - This is a classical separation of concerns, where you extract a distinct responsibility into a separate abstraction, and then create another abstraction on top of it.

Chapter 4.1.3 Structuring data with maps
  - If you want to extend an entry with another attribute — such as time — you must change the signature of the function, which will in turn break all the clients.
  - An obvious solution to this problem is to somehow combine all entry fields as a single data abstraction.
  ```Elixir
  defmodule TodoList do  
    ...  
    def add_entry(todo_list, entry) do    
      MultiDict.add(todo_list, entry.date, entry)  
    end  
    ...
  end
  ```
  ```Elixir
  iex(1)> todo_list = TodoList.new() |>          
            TodoList.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})
  iex(2)> TodoList.entries(todo_list, ~D[2018-12-19])
  [%{date: ~D[2018-12-19], title: "Dentist"}]
  ```

Chapter 4.1.4 Abstracting with structs
  - Elixir provides a facility called structs that allows you to specify the abstraction structure up front and bind it to a module.
  - Each module can define only one struct, which can then be used to create new instances and pattern-match on them.
  - Defining a struct:
  ```Elixir
  defmodule Fraction do  
    defstruct a: nil, b: nil  
      ...
  end
  ```
  - A keyword list provided to defstruct defines the struct’s fields together with their initial values.
  - You can now instantiate a struct using this special syntax:
  ```Elixir
  iex(1)> one_half = %Fraction{a: 1, b: 2}
  %Fraction{a: 1, b: 2}
  iex(2)> one_half.a
  1
  iex(3)> one_half.b
  2
  iex(4)> %Fraction{a: a, b: b} = one_half
  %Fraction{a: 1, b: 2}
  iex(5)> a
  1
  iex(6)> b
  2
  iex(6)> %Fraction{} = one_half                                   
  %Fraction{a: 1, b: 2}
  iex(7)> %Fraction{} = %{a: 1, b: 2}                             
  ** (MatchError) no match of right hand side value: %{a: 1, b: 2}
  iex(8)> one_quarter = %Fraction{one_half | b: 4}
  %Fraction{a: 1, b: 4}
  ```
  - A struct may exist only in a module, and a single module can define only one struct.
  - The nice thing about structs is that you can pattern-match on them which makes it possible to assert that some variable is really a struct
  - Creating a fraction function:
  ```Elixir
  defmodule Fraction do  
    ...  
    def new(a, b) do    
      %Fraction{a: a, b: b}  
    end  
    def value(%Fraction{a: a, b: b}) do          
      a / b  
    end
    ...
    def add(%Fraction{a: a1, b: b1}, %Fraction{a: a2, b: b2}) do    
      new(      
        a1 * b2 + a2 * b1,      
        b2 * b1    
      )  
    end
  end
  ```
  ```Elixir
  iex(1)> Fraction.add(Fraction.new(1, 2), Fraction.new(1, 4)) |>          
            Fraction.value()
  0.75
  ```
  - Instead of decomposing fields into variables, you could also use dot notation:
  ```Elixir
  def value(fraction) do  
    fraction.a / fraction.b
  end
  ```
  - It’s possible to distinguish struct instances from any other data type. This allows you to place %Fraction{} matches in function arguments, thus asserting that you only accept fraction instances.
  - You should always be aware that structs are in reality just maps, so they have the same characteristics with respect to performance and memory usage. But structs get special treatment.
  - In fraction abstraction you must define whether it is enumerable and in what way or it isn't an enumerable.
  - Unlike structs maps are enumerable.
  - Since structs are maps you can directly call Map functions on it.
  ```Elixir
  iex(1)> one_half = Fraction.new(1, 2)
  iex(2)> Map.to_list(one_half)
  [__struct__: Fraction, a: 1, b: 2]
  ```
  - The ``` _struct_: Fraction``` bit key/value pair is automatically included in each struct. This is to help Elixir distinguish structs from maps.
  - A struct can't match a plain map, but a plain map pattern can match a struct.
  - Records can be defined using the defrecord and defrecordp macros from the Record module
  - Before maps appeared, records were one of the main tools for structuring data.
  - If you need to interface an Erlang library using a record defined in that library, you must import that record into Elixir and define it as a record.

Chapter 4.1.5 Data transparency
  - It’s important to be aware that data in Elixir is always transparent.
  - Clients can read any information from your structs (and any other data type), and there’s no easy way of preventing that.
  - In Elixir, modules are in charge of abstracting the data and providing operations to manipulate and query that data, but the data is never hidden.
  - Data privacy can’t be enforced in functional abstractions; you can see the naked structure of the data.
  - The benefit of data transparency is that the data can be easily inspected, which can be useful for debugging purposes
  - IO.inspect/1 prints the inspected representation of a structure to the screen and returns the structure itself.
  ```Elixir
  iex(1)> Fraction.new(1, 4) |>          
            IO.inspect() |>          
            Fraction.add(Fraction.new(1, 4)) |>          
            IO.inspect() |>          
            Fraction.add(Fraction.new(1, 2)) |>          
            IO.inspect() |>          
            Fraction.value()

  %Fraction{a: 1, b: 4}          
  %Fraction{a: 8, b: 16}        
  %Fraction{a: 32, b: 32}
  ```

Chapter 4.2 Working with hierarchical data

Chapter 4.2.1 Generating IDs
  - Transform the to-do list into a struct
  - Use the entry’s ID as the key
  ```Elixir
  defmodule TodoList do  
    defstruct auto_id: 1, entries: %{} # struct that describes the to-do list       

    def new(), do: %TodoList{}         # Creates new instance                      
    ...
  end
  ```
  - The instantiation function new/0 creates and returns an instance of the struct.
  - add_entry/2 function has to do more work:
    -	Set the ID for the entry being added
    -	Add the new entry to the collection.
    -	Increment the auto_id field.
  ```Elixir
  defmodule TodoList do  
    ...
    def add_entry(todo_list, entry) do    
      entry = Map.put(entry, :id, todo_list.auto_id)   

      new_entries = Map.put(                                                
        todo_list.entries,                                          
        todo_list.auto_id,                                          
        entry                                                   
      )                                                       

      %TodoList{todo_list |                                         
        entries: new_entries,                                       
        auto_id: todo_list.auto_id + 1                            
        }  
    end
    ...
  end
  ```
  - Notice how you use Map.put/3 to update the entry map. The input map may not contain the id field, so you can’t use the standard %{entry | id: auto_id} technique, which works only if the id field is already present in the map.
  - Filtering entries for a given date:
  ```Elixir
  defmodule TodoList do  
    ...

    def entries(todo_list, date) do    
        todo_list.entries    
        |> Stream.filter(fn {_, entry} -> entry.date == date end)      
        |> Enum.map(fn {_, entry} -> entry end)                      
    end  
    ...
  end
  ```
  ```Elixir
  iex(1)> todo_list = TodoList.new() |>          
            TodoList.add_entry(%{date: ~D[2018-12-19], title: "Dentist"})  |>          
            TodoList.add_entry(%{date: ~D[2018-12-20], title: "Shopping"}) |>          
            TodoList.add_entry(%{date: ~D[2018-12-19], title: "Movies"})

  iex(2)> TodoList.entries(todo_list, ~D[2018-12-19])
  [  
    %{date: ~D[2018-12-19], id: 1, title: "Dentist"},  
    %{date: ~D[2018-12-19], id: 3, title: "Movies"}
  ]
  ```

Chapter 4.2.2 Updating entries
  - How will the update_entry function be used? There are two possible options:
    -	The function will accept an ID value for the entry and an updater lambda. This will work similarly to Map.update. The lambda will receive the original entry and return its modified version.
    - The function will accept an entry map. If an entry with the same ID exists in the entries collection, it will be replaced.
 - If an entry doesnt exist you either do nothing or raise an error.
 - Updating an entry:
 ```Elixir
 defmodule TodoList do  
    ...
    def update_entry(todo_list, entry_id, updater_fun) do    
      case Map.fetch(todo_list.entries, entry_id) do      
        :error ->            #No entry — returns  the unchanged list                                   
          todo_list
        {:ok, old_entry} ->  #Entry exists — performs the update  and returns the modified list
          new_entry = updater_fun.(old_entry)        
          new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)        
          %TodoList{todo_list | entries: new_entries}    
      end  
    end
    ...
 end
 ```
 ```Elixir
 iex(1)> TodoList.update_entry(          
            todo_list,          
            1,                                    #ID of the entry to be modified
            &Map.put(&1, :date, ~D[2018-12-20])   #Modifies an entry date          
         )
 ```
 - update_entry/3 works fine, but it’s not quite bulletproof. The updater lambda can return any data type:
 ```Elixir
 new_entry = %{} = updater_fun.(old_entry)
 ```
 - Assert that the ID value of the entry hasn’t been changed in the lambda:
 ```Elixir
 old_entry_id = old_entry.id
 new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
 ```
 - ^var in a pattern match means you’re matching on the value of the variable.

Chapter 4.2.3 Immutable hierarchical updates
  - If you have hierarchical data, you can’t directly modify part of it that resides deep in its tree. Instead, you have to walk down the tree to the particular part that needs to be modified, and then transform it and all of its ancestors.
  - The two versions — new and previous — will share as much memory as possible
  - Remember, to update an element deep in the hierarchy, you have to walk to that element and then update all of its parents. To simplify this, Elixir offers support for more elegant deep hierarchical updates.
  - Functions and macros, such as put_in/2, rely on the Access module, which allows you to work with key/value structures such as maps.
  - You can also make your own abstraction work with Access.  You need to implement a couple of functions required by the Access contract, and then put_in and related macros and functions will know how to work with your own abstraction.

Chapter 4.2.4 Iterative updates
  - Iteratively building the to-do list
  ```Elixir
  defmodule TodoList do  
    ...
    def new(entries \\ []) do
       Enum.reduce(      
            entries,      
            %TodoList{},                                 
            fn entry, todo_list_acc ->                     
              add_entry(todo_list_acc, entry)            
            end                                        
        )  
    end  
    ...
  end
  ```
  - Enum.reduce/3 is used to transform something enumerable to anything else.

Chapter 4.2.5 Exercise: importing from a file

Chapter 4.3 Polymorphism with protocols
  - Polymorphism is a runtime decision about which code to execute, based on the nature of the input data.
  - In Elixir, the basic (but not the only) way of doing this is by using the language feature called protocols.

Chapter 4.3.1 Protocol basics
  - A protocol is a module in which you declare functions without implementing them.
  - A protocol is roughly equivalent to an OO interface.
  - Kernel.to_string/1 delegates to the String.Chars implementation.

Chapter 4.3.2 Implementing a protocol
  - You start the implementation by calling the defimpl macro.
  -  Then you specify which protocol to implement and the corresponding data type, the type can be any other arbitrary alias .
  -  Finally, the do/end block contains the implementation of each protocol function.
  ```Elixir
  defimpl String.Chars, for: Integer do  
    def to_string(term) do    
      Integer.to_string(term)  
    end
  end
  ```
  - The for: Type part deserves some explanation. The type is an atom and can be any of following aliases: Tuple, Atom, List, Map, BitString, Integer, Float, Function, PID, Port, or Reference.

Chapter 4.3.3 Built-in protocols
  - List.Chars protocol, which converts input data to a character string
  - To control how your structure is printed in the debug output, you can implement the Inspect protocol.
  -  A collectable can be used with comprehensions to collect results or with Enum.into/2 to transfer elements of one structure (enumerable) to another (collectable).
  
