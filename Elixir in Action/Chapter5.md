Chapter 5 Concurrency primitives

Chapter 5.1 Concurrency in BEAM
  - Erlang is all about writing highly available systems — systems that run forever and are always able to meaningfully respond to client requests. To make your system highly available, you have to tackle the following challenges:
    1. Fault-tolerance — Minimize, isolate, and recover from the effects of runtime errors.
    2. Scalability — Handle a load increase by adding more hardware resources without changing or redeploying the code.
    3. Distribution — Run your system on multiple machines so that others can take over if one machine crashes.
  - In BEAM, the unit of concurrency is a process: a basic building block that makes it possible to build scalable, fault-tolerant, distributed systems.
  - A BEAM process shouldn’t be confused with an OS process. As you’re about to learn, BEAM processes are much lighter and cheaper than OS processes.
  - Processes help us run things in parallel, allowing us to achieve scalability — the ability to address a load increase by adding more hardware power that the system automatically takes advantage of.
  - Processes also ensure isolation, which in turn gives us fault-tolerance — the ability to localize and limit the impact of unexpected runtime errors that inevitably occur. If you can localize exceptions and recover from them, you can implement a system that truly never stops, even when unexpected errors occur.
  - By default, BEAM uses as many schedulers as there are CPU cores available.
  - A scheduler is in charge of the interchangeable execution of processes.
  - Processes are light. It takes only a couple of microseconds to create a single process, and its initial memory footprint is a few kilobytes. By comparison, OS threads usually use a couple of megabytes just for the stack.

Chapter 5.2 Working with processes
  - It’s important to realize that concurrency doesn’t necessarily imply parallelism. Two concurrent things have independent execution contexts, but this doesn’t mean they will run in parallel. If you run two CPU-bound concurrent tasks and you only have one CPU core, parallel execution can’t happen. You can achieve parallelism by adding more CPU cores and relying on an efficient concurrent framework. But you should be aware that concurrency itself doesn’t necessarily speed things up.

Chapter 5.2.1 Creating processes
  - To create a process, you can use the auto-imported spawn/1 function:
  ```elixir
  spawn(fn ->  
    expression_1       
    ...                
    expression_n     
  end)
  ```
  - The function spawn/1 takes a zero-arity lambda that will run in the new process
  - In BEAM, everything runs in a process. This also holds for the interactive shell. All expressions you enter in iex are executed in a single shell-specific process.

Chapter 5.2.2 Message passing
  - The process mailbox is a FIFO queue limited only by the available memory.
  - To send a message to a process, you need to have access to its process identifier (pid).
  - You can obtain the pid of the current process by calling the auto-imported self/0 function.
  - Once you have a receiver’s pid, you can send it messages using the Kernel.send/2 function:
  ```elixir
  send(pid, {:an, :arbitrary, :term})
  ```
  - The consequence of send is that a message is placed in the mailbox of the receiver.
  - On the receiver side, to pull a message from the mailbox, you have to use the receive expression:
  ```elixir
  receive do  
    pattern_1 -> do_something  
    pattern_2 -> do_something_else
  end
  ```
  - The receive expression works similarly to the case expression
  - If you want to handle a specific message, you can rely on pattern matching:
  ```elixir
  receive do          
    {:message, id} ->                                  
      IO.puts("received message #{id}")        
  end
  ```
  - If there are no messages in the mailbox, receive waits indefinitely for a new message to arrive.
  - If you don’t want receive to block, you can specify the after clause, which is executed if a message isn’t received in a given time frame
  ```elixir
  receive do          
    message -> IO.inspect(message)        
  after          
    5000 -> IO.puts("message not received")        
  end
  ```
  - If a message doesn’t match any of the provided clauses, it’s put back into the process mailbox, and the next message is processed.
  - The receive expression works as follows:
    1. Take the first message from the mailbox.
    2. Try to match it against any of the provided patterns, going from top to bottom.
    3. If a pattern matches the message, run the corresponding code.
    4. If no pattern matches, put the message back into the mailbox at the same position it originally occupied. Then try the next message.
    5. If there are no more messages in the queue, wait for a new one to arrive. When a new message arrives, start from step 1, inspecting the first message in the mailbox.
    6. If the after clause is specified and no message is matched in the given amount of time, run the code from the after block.
  - The basic message-passing mechanism is the asynchronous “fire and forget” kind. A process sends a message and then continues to run

Chapter 5.3 Stateful server processes
  - Stateful server processes resemble objects. They maintain state and can interact with other processes via messages. But a process is concurrent, so multiple server processes can run in parallel.

Chapter 5.3.1 Server processes
  - A server process is an informal name for a process that runs for a long time (or forever) and can handle various requests (messages).
  - A function that always calls itself will run forever, without causing a stack overflow or consuming additional memory.
  - Server Process:
  ```elixir
  defmodule DatabaseServer do  
    def run_async(server_pid, query_def) do    
      send(server_pid, {:run_query, self(), query_def})  
    end

    def start do    
      spawn(&loop/0)     
    end

    def get_result do    
      receive do      
        {:query_result, result} -> result    
      after      
        5000 -> {:error, :timeout}    
      end  
    end

    defp loop do    
      receive do             
        {:run_query, caller, query_def} ->
          send(caller, {:query_result, run_query(query_def)})                 
      end              

      loop()             
    end  

    defp run_query(query_def) do             
      Process.sleep(2000)                     
      "#{query_def} result"                
    end
    ...
  end
  ```
  - start/0 is the so-called interface function that’s used by clients to start the server process.
  - A module is just a collection of functions, and these functions can be invoked in any process.
  - When implementing a server process, it usually makes sense to put all of its code in a single module.
  - The functions of this module generally fall into two categories: interface and implementation.
    - Interface functions are public and are executed in the caller process. They hide the details of process creation and the communication protocol.
    - Implementation functions are usually private and run in the server process.
  - A standard abstraction called GenServer (generic server process) is provided, which simplifies the development of stateful server processes. The abstraction still relies on recursion, but this recursion is implemented in GenServer.

Chapter 5.3.2 Keeping a process state
  - Server processes open the possibility of keeping some kind of process-specific state. For example, when you talk to a database, you need a connection handle that’s used to communicate with the server. If your process is responsible for TCP communication, it needs to keep the corresponding socket.

Chapter 5.3.3 Mutable state

Chapter 5.3.4 Complex states

Chapter 5.3.5 Registered processes
  - The following rules apply to registered names:
  	 1. The name can only be an atom.
     2.	A single process can have only one name.
     3.	Two processes can’t have the same name.

Chapter 5.4 Runtime considerations

Chapter 5.4.1 A process is sequential
  - If many processes send messages to a single process, that single process can significantly affect overall throughput.
  - Parallelization isn’t a remedy for a poorly structured algorithm.

Chapter 5.4.2 Unlimited process mailboxes
  - A single slow process may cause an entire system to crash by consuming all the available memory.
  - For each server process, you should introduce a match-all receive clause that deals with unexpected kinds of messages. Typically, you’ll log that a process has received the unknown message, and do nothing else about it.

Chapter 5.4.3 Shared-nothing concurrency
  - Deep-copying is an in-memory operation, so it should be reasonably fast, and occasionally sending a big message shouldn’t present a problem.
  - Having many processes frequently send big messages may affect system performance.
  - Because processes share no memory, garbage collection can take place on a process level.

Chapter 5.4.4 Scheduler inner workings
  - A list of all Erlang flags can be found at http://erlang.org/doc/man/erl.html.
  - In general, you can assume that there are n schedulers that run m processes, with m most often being significantly larger than n. This is called m:_n_ threading, and it reflects the fact that you run a large number of logical microthreads using a smaller number of OS threads
