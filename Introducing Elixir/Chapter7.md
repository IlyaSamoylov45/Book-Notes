Chapter 7 Name-Value Pairs

Keyword Lists
  - A keyword list is always sequential and can have duplicate keys.
  - Use Keyword.get/3 to retrieve the first value in the list with a given key.
  - You can use Keyword.has_key?/2 to see if a key exists in the list
  - To add a new value, use Keyword.put_new/3.
  - To replace a value, use Keyword.put/3 If the key doesn’t exist, it will be created. If it does exist, all entries for that key will be removed and the new entry added.
  - If you want to delete all entries for a key, use Keyword.delete/2
  - To delete only the first entry for a key, use Keyword.delete_first/2

Lists of Tuples with Multiple Keys
  - List.keyfind/4
  - List.keymem ber?/3
  - List.keyreplace/4
  - List.keystore/4
  - List.keydelete/3

Hash Dictionaries
  - The advantage of a HashDict over a Keyword list is that it works well for large amounts of data.

From Lists to Maps
  - Keyword lists are a convenient way to address content stored in lists by key, but underneath, Elixir is still walking through the list.

  ```Elixir
  iex(12)> %{earth: earth_gravity} = planemo_map
  %{earth: 9.8, mars: 3.71, moon: 1.6}
  iex(13)> earth_gravity
  9.8
  ```

From Maps to Structs
  - Elixir structs are based on map
  - A struct also keeps track of the key names and makes sure you don’t use invalid keys.

  ```Elixir
  defmodule Planemo do  
    defstruct name: :nil, gravity: 0, diameter: 0, distance_from_sun: 0
  end
  ```
