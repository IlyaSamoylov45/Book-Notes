Chapter 3 exercises Notes:
  - In Elixir all code runs inside processes
  - Processes are isolated from each other, run concurrent to one another and communicate via message passing.
  - Provide the means for building distributed and fault-tolerant programs.
  - Elixir’s processes should not be confused with operating system processes.
  - Processes in Elixir are extremely lightweight in terms of memory and CPU (even compared to threads as used in many other programming languages).
  - spawn:
      - The basic mechanism for spawning new processes
      - auto-imported

      ```Elixir
      iex> pid = spawn fn -> 1 + 2 end
      #PID<0.44.0>
      iex> Process.alive?(pid)
      false
      iex> self()
      #PID<0.41.0>
      iex> Process.alive?(self())
      true
      ```

  - send and receive

      ```elixir
      iex> send self(), {:hello, "world"}
      {:hello, "world"}
      iex> receive do
      ...>   {:hello, msg} -> msg
      ...>   {:world, msg} -> "won't match"
      ...> end
      "world"
      ```

      ```elixir
      iex> parent = self()
      #PID<0.41.0>
      iex> spawn fn -> send(parent, {:hello, self()}) end
      #PID<0.48.0>
      iex> receive do
      ...>   {:hello, pid} -> "Got hello from #{inspect pid}"
      ...> end
      "Got hello from #PID<0.48.0>"
      ```

    - The inspect/1 function is used to convert a data structure’s internal representation into a string, typically for printing.  
    - flush/0 flushes and prints all the messages in the mailbox.

      ```Elixir
      iex> send self(), :hello
      :hello
      iex> flush()
      :hello
      :ok
      ```
  - Links
    - Processes are isolated
    - If we want the failure in one process to propagate to another one, we should link them.
    - This can be done with spawn_link/1
    - Linking can also be done manually by calling Process.link/1
    - A failure in a process will never crash or corrupt the state of another process. Links, however, allow processes to establish a relationship in case of failure.

  - Tasks
    - Tasks build on top of the spawn functions to provide better error reports and introspection:
    - We use Task.start/1 and Task.start_link/1 which return {:ok, pid} rather than just the PID.

  - State
    - We can write processes that loop infinitely, maintain state, and send and receive messages.

    ```Elixir
    defmodule KV do
      def start_link do
        Task.start_link(fn -> loop(%{}) end)
      end

      defp loop(map) do
        receive do
          {:get, key, caller} ->
            send caller, Map.get(map, key)
            loop(map)
          {:put, key, value} ->
            loop(Map.put(map, key, value))
        end
      end
    end
    ```

    ```Elixir
    iex> {:ok, pid} = KV.start_link
    {:ok, #PID<0.62.0>}
    iex> send pid, {:get, :hello, self()}
    {:get, :hello, #PID<0.41.0>}
    iex> flush()
    nil
    :ok
    iex> send pid, {:put, :hello, :world}
    {:put, :hello, :world}
    iex> send pid, {:get, :hello, self()}
    {:get, :hello, #PID<0.41.0>}
    iex> flush()
    :world
    :ok
    ```

    - Notice how the process is keeping a state and we can get and update this state by sending the process messages. In fact, any process that knows the pid above will be able to send it messages and manipulate the state.
    - It is also possible to register the pid, giving it a name, and allowing everyone that knows the name to send it messages

    ```Elixir
    iex> Process.register(pid, :kv)
    true
    iex> send :kv, {:get, :hello, self()}
    {:get, :hello, #PID<0.41.0>}
    iex> flush()
    :world
    :ok
    ```

    - Using processes to maintain state and name registration are very common patterns in Elixir applications.
