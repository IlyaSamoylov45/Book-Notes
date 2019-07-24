Chapter 11 Storing Structured Data

Records: Structured Data Before structs

Setting Up Records
  -  Instead of saying defmodule, you use a defrecord declaration:
  ```elixir
  defrecord Planemo, name: :nil, gravity: 0, diameter: 0, distance_from_sun: 0
  ```
  - You may want to put each record declaration in a separate file or all of them in a single file, depending on your needs.
  ```elixir
  defmodule Planemo do  
    require Record  
    Record.defrecord :planemo, [name: :nil, gravity: 0, diameter: 0,  distance_from_sun: 0]
  end

  defmodule Tower do  
    require Record  
    Record.defrecord :tower, Tower,    
    [location: "", height: 20, planemo: :earth, name: ""]
  end
  ```
  - Record.defrecord constructs a set of macros to create and access a record. The first item after Record.defrecord is the record name. The second item is optional; it is the tag. If you don’t provide a tag, Elixir uses the record name.

Creating and Reading Records
  - You create a new record by using the record name function
  ```elixir
  iex(1)> c("records.ex") [Tower,Planemo]
  iex(2)> require Tower
  nil
  iex(3)> tower1 = Tower.tower()
  {Tower, "", 20, :earth, ""}
  iex(4)> tower2 = Tower.tower(location: "Grand Canyon")
  {Tower, "Grand Canyon", 20, :earth, ""}
  iex(5)> tower3 = Tower.tower(location: "NYC", height: 241,
  ...(5)> name: "Woolworth Building")
  {Tower, "NYC", 241, :earth, "Woolworth Building"}
  iex(6)> tower4 = Tower.tower location: "Rupes Altat 241", height: 500,
  ...(6)> planemo: :moon, name: "Piccolini View"
  {Tower, "Rupes Altat 241", 500, :moon, "Piccolini View"}
  iex(7)> tower5 = Tower.tower planemo: :mars, height: 500,
  ...(7)> name: "Daga Vallis", location: "Valles Marineris"
  {Tower, "Valles Marineris", 500, :mars, "Daga Vallis"}
  ```
  - To extract a single value, you can use a dot (.) syntax
  ```elixir
  iex(8)> Tower.tower(tower5, :planemo)
  :mars
  iex(9)> import Tower
  nil
  iex(10)> tower(tower5, :height)
  500
  ```
  - If you want to change a value in a record, you can do so.
  ```elixir
  iex(11)> tower5
  {Tower, "Valles Marineris", 500, :mars, "Daga Vallis"}
  iex(12)> tower5 = tower(tower5, height: 512)
  {Tower, "Valles Marineris", 512, :mars, "Daga Vallis"}
  ```

Using Records in Functions
  - You can pattern match against records submitted as arguments.

Storing Data in Erlang Term Storage
  - Erlang Term Storage (ETS) is a simple but powerful in-memory collection store.
  - Every entry in an ETS tables is a tuple (or corresponding record), and one piece of the tuple is designated the key.
  - ETS can hold four kinds of collections:
    1. Sets (:set)
       - Can contain only one entry with a given key. This is the default.
    2. Ordered sets (:ordered_set)
       - Same as a set, but also maintains a traversal order based on the keys. Great for anything you want to keep in alphabetic or numeric order.
    3. Bags (:bag)
       - Lets you store more than one entry with a given key. However, if you have multiple entries that have completely identical values, they get combined into a single entry.
    4. Duplicate bags (:duplicate_bag)
       - Not only lets you store more than one entry with a given key, but also lets you store multiple entries with completely identical values.

Creating and Populating a Table
  - The :ets.new/2 function lets you create a table. The first argument is a name for the table, and the second argument is a list of options.
  - Every table has a name, but only some can be reached using that name. If you don’t specify :named_table, the name is there but visible only inside the database. You’ll have to use the value returned by :ets.new/2 to reference the table.
  - If you do specify :named_table, processes can reach the table as long as they know the name, without needing access to that return value.
  - By default, ETS treats the first value in a tuple as the key.
  ```elixir
  defmodule Planemo do  
    require Record  
    Record.defrecord :planemo, [name: :nil, gravity: 0, diameter: 0,  
    distance_from_sun: 0]
  end
  ```
  - An appropriate declaration for setting up the ETS table might look like the following:
  ```elixir
  planemo_table = :ets.new(:planemos,[ :named_table, {:keypos,  
  Planemo.planemo(:name) + 1} ])
  ```
  - That gives the table the name :planemos and uses the :named_table option to make that table visible to other processes that know the name.
  - Because of the default access level of :protected, this process can write to that table but other processes can only read it.
  - It also tells ETS to use the :name field as the key
  - The call to the planemo function returns the index of the field in the underlying Elixir tuple, with the first entry numbered as zero. That’s why the preceding code had to add one.
  - You use the :ets.info/1 function to check out its details
  ```elixir
  defmodule PlanemoStorage do  
    require Planemo

    def setup do    
      planemo_table = :ets.new(:planemos,[:named_table,      
        {:keypos, Planemo.planemo(:name) + 1}])    
      :ets.info planemo_table  
    end
  end
  ```
  - You can set up only one ETS table with the same name. If you call PlanemoStorage.set up/0 twice, you’ll get an error.
  - Use :ets.insert/2 to add content to the table.
  - If you want to see what’s in that table, you can do it from the shell by using the :ets.tab2list/1 function, which will return a list of records, broken into separate lines for ease of reading.

Simple Queries
  - The easiest way to look up records in your ETS table is with the :ets.lookup/2 function and the key.
  ```elixir
  iex(11)> result = hd(:ets.lookup(:planemos, :eris))
  {:planemo, :eris, 0.8, 2400, 10210.0}
  iex(12)> Planemo.planemo(result, :gravity)
  0.8
  ```

Overwriting Values
- Although you can re-assign values to Elixir variables, it’s better if you don’t overwrite the value of a variable or change the value of an item in a list.
- Just because you can change values in an ETS table, however, doesn’t mean that you should rewrite your code to replace variables with flexible ETS table contents.

ETS Tables and Processes
  - You can use Erlang’s match specifications and :ets.fun2ms to create more complex queries with :ets.match and :ets.select.
  - You can delete rows (as well as tables) with :ets.delete. The :ets.first, :ets.next, and :ets.last functions let you traverse tables recursively.
  - DETS, the Disk-Based Term Storage, offers similar features but with tables stored on disk. It’s slower, with a 2 GB limit, but the data doesn’t vanish when the controlling process stops.
  - If your needs are more complex, and especially if you need to split data across multiple nodes, you should probably explore the Mnesia database.

Storing Records in Mnesia
  - Mnesia is a database management system (DBMS) that comes with Erlang, and, by extension, one that you can use with Elixir.
  - It uses ETS and DETS underneath, but provides many more features than those components.
  - You should consider shifting from ETS (and DETS) tables to the Mnesia database if:
    - You need to store and access data across a set of nodes, not just a single node.
    - You don’t want to have to think about whether you’re going to store data in memory or on a disk or both.
    - You need to be able to roll back transactions if something goes wrong.
    - You’d like a more approachable syntax for finding and joining data.
    - Management prefers the sound of “database” to the sound of “tables.”
  - Before you turn Mnesia on, you need to create a database, using the :mnesia.create_schema/ 1 function.
  - For now, because you’ll be getting started using only the local node, that will look like the following:
  ```Elixir
  iex(1)> :mnesia.create_schema([node()]) :ok
  ```
  - Mnesia will store schema data in the directory where you are when you start it. If you look in the directory where you started Elixir, you’ll see a new directory with a name like Mnesia.nonode@nohost.
  - Unlike ETS and DETS, which are always available, you need to turn Mnesia on:
  ```elixir
  iex(2)> :mnesia.start() :ok
  ```
  - There’s also a :mnesia.stop/0 function if you want to stop it.
  - If you run Mnesia on a computer that goes to sleep, you may get odd messages like Mnesia(nonode@nohost): ** WARNING ** Mnesia is overloaded: {dump_log, time_threshold} when it wakes up. Don’t worry, it’s a side effect of waking up, and your data should still be safe.

Creating Tables
  - Like ETS, Mnesia’s basic concept of a table is a collection of records.
  - It also offers :set, :orderered_set, and :bag options, just like those in ETS, but doesn’t offer :duplicate_bag.
  - Mnesia wants to know more about what you store, and takes a list of field names.
  - The easy way to handle this is to define records and consistently use the field names from the records as Mnesia field names.
  - You give the record name explicitly with this code: {:record_name, :planemo}
  - The :mnesia_write calls take three parameters: the table name, the record, and the type of lock to use on the database (in this case, :write).
  - The key thing to note is that all of the writes are contained in a fn that is then passed to :mnesia.transaction to be executed as a transaction.
  - Mnesia will restart the transaction if there is other activity blocking it, so the code may get executed repeatedly before the transaction happens.
  - Your interactions with Mnesia should be contained in transactions, especially when your database is shared across multiple nodes.
  - The main :mnesia.write, :mne sia.read, and :mnesia.delete methods work only within transactions, period.
  - There are dirty_ methods, but every time you use them, especially to write data to the database, you’re taking a risk.
  - If you want to check on how this function worked out, try the :mnesia.table_info function.
  - By default, Mnesia will store your table in RAM only (ram_copies) on the current node. This is speedy, but it means the data vanishes if the node crashes.
  - Mnesia will keep a copy of the database on disk, but still use RAM for speed.
  - Unlike ETS, the table you create will still be around if the process that created it crashes, and will likely survive even a node crash so long as it wasn’t only in RAM on a single node.

Reading Data
  - Just like writes, you should wrap :mnesia.read calls in a fn, which you then pass to :mnesia.transaction.
