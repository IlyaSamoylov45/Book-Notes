Chapter 12 Getting started with OTP
  - OTP, the Open Telecom Platform, is useful for pretty much any large-scale project you want to do with Elixir and Erlang, not just telecom work.
  - The most common behaviors are GenServer (generic server) and Supervisor.
  - Elixir provides the Mix build tool for creating applications so that you can package your OTP code into a single runnable (and updatable) system.

Creating Services with gen_server
  - It provides a core set of methods that let you set up a process, respond to requests, end the process gracefully, and even pass state to a new process if this one needs to be upgraded in place.
  1. Method : init/1
     - Triggered by : GenServer.start_link
     - Does : Sets up the process
  2. Method : handle_call/3  
     - Triggered by : GenServer.call
     - Does : Handles synchronous calls
  3. Method : handle_cast/2
     - Triggered by : GenServer.cast  
     - Does : Handles asynchronous calls
  4. Method : handle_info/2  
     - Triggered by : random messages  
     - Does : Deals with non-OTP messages
  5. Method : terminate/2  
     - Triggered by : failure or shutdown signal from supervisor  
     - Does : Cleans up the process
  6. Method : code_change/3  
     - Triggered by : system libraries for code upgrades
     - Does : Lets you switch out code without losing state
  - The start_link/0 function uses the built-in MODULE declaration, which returns the name of the current module..
  ```Elixir
  # This is a convenience method for startup
  def start_link do   
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end
  ```
  - By default, the name of the process is registered with just the local Elixir instance. Because we want it registered with all associated nodes, we have put the tuple {:name, MODULE} in the options list.
  - By default, OTP will time out any synchronous calls that take longer than five seconds to calculate. You can override this by making your call using GenServer.call/3 to specify a timeout (in milliseconds) explicitly, or by using the atom :infinity.
  - Making a GenServer process run and calling it looks a little different than starting the processes
  ```elixir
  iex(1)> c("drop_server.ex")
  [DropServer,DropServer.State]
  iex(2)> DropServer.start_link()
  {:ok,#PID<0.46.0>}
  iex(3)> GenServer.call(DropServer, 20)
  {:ok,19.79898987322333}
  iex(4)> GenServer.call(DropServer, 40)
  {:ok,28.0}
  iex(5)> GenServer.call(DropServer, 60)
  {:ok,34.292856398964496}
  iex(6)> GenServer.cast(DropServer, {})
  So far, calculated 3 velocities.
  :ok
  ```
  -  OTP has other mechanisms for updating code on the fly. There is also a built-in limitation to this approach: init gets called only when start_link sets up the service. It does not get called if you recompiled the code.

A Simple Supervisor
  - When you started the DropServer module from the shell, you effectively made the shell the supervisor for the module—though the shell doesn’t really do any supervision. You can break the module easily:
  ```elixir
  iex(9)> GenServer.call(DropServer, -60)

  =ERROR REPORT==== 28-Jun-2014::08:17:52 ===
    ** (EXIT from #PID<0.42.0>) an exception was raised:
      ** (ArithmeticError) bad argument in arithmetic expression        
          (stdlib) :math.sqrt(-1176.0)
          drop_server.ex:44: DropServer.fall_velocity/1        
          drop_server.ex:20: DropServer.handle_call/3        
          (stdlib) gen_server.erl:580: :gen_server.handle_msg/5        
          (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3

  Interactive Elixir (1.0.0-rc2) - press Ctrl+C to exit (type h() ENTER for help)

  08:52:00.459 [error] GenServer DropServer terminating
  Last message: -60
  State: %DropServer.State{count: 3}
  ** (exit) an exception was raised:    
      ** (ArithmeticError) bad argument in arithmetic expression        
          (stdlib) :math.sqrt(-1176.0)        
          drop_server.ex:44: DropServer.fall_velocity/1        
          drop_server.ex:20: DropServer.handle_call/3        
          (stdlib) gen_server.erl:580: :gen_server.handle_msg/5        
          (stdlib) proc_lib.erl:239: :proc_lib.init_p_do_apply/3
  ```
  - The error message is nicely complete, even telling you the last message and the state, but when you go to call the service again, you can’t, because the IEx shell has restarted.
  - You can restart it with DropServer.start_link/0 again, but you’re not always going to be watching your processes personally.
  - You want something that can watch over your processes and make sure they restart (or not) as appropriate. OTP formalizes the process management with its supervisor behavior.
  - A basic supervisor needs to support only one callback function, init/1, and can also have a start_link function to fire it up.
  ```elixir
  defmodule DropSup do  
    use Supervisor

    # convenience method for startup

    def start_link do    
      Supervisor.start_link(__MODULE__, [], [{:name, __MODULE__}])  
    end

    # supervisor callback

    def init([]) do    
      child = [worker(DropServer, [], [])]    
      supervise(child, [{:strategy, :one_for_one}, {:max_restarts, 1},      
        {:max_seconds, 5}])  
    end

    # Internal functions (none here)
    end
  ```
  - The init/1 function’s job is to specify the process or processes that the supervisor is to keep track of, and specify how it should handle failure.
  - The worker/3 function specifies a module that the supervisor should start, its argument list, and any options to be given to the worker’s start_link function.
  - The supervise/2 function takes the list of child processes as its first argument and a list of options as its second argument.
  - The :strategy of :one_for_one tells OTP that it should create a new child process every time a process that is supposed to be :permanent (the default) fails.
  - You can also go with :one_for_all, which terminates and restarts all of the processes the supervisor oversees when one fails, or :rest_for_one, which restarts the process and any processes that began after the failed process had started.
  - The next two values define how often the worker processes can crash before terminating the supervisor itself. In this case, it’s one restart every five seconds.
  - Setting :max_restarts to zero means that the supervisor will just terminate if a worker has an error.
  - The supervise function takes those arguments and creates a data structure that OTP will use.
  - More complex OTP applications can contain trees of supervisors managing other supervisors, which themselves manage other supervisors or workers.
  - To create a child process that is a supervisor, you use the supervisor/3 function, whose arguments are the same as those of worker/3.
  - Running a supervisor from the shell using the start_link/0 function call creates its own set of problems; the shell is itself a supervisor, and will terminate processes that report errors. After a long error report, you’ll find that both your worker and the supervisor have vanished.

Packaging an Application with Mix
  - Elixir’s Mix tool “provides tasks for creating, compiling, testing (and soon deploying) Elixir projects.”
  - Create a directory to hold your application, type mix new name
  ```
  $ mix new drop_app
  ```
  - Make sure that the Elixir executable is in your $PATH variable so that Mix can find it.
  - Mix creates a set of files and directories for you.
  ```elixir
  defmodule DropApp.Mixfile do  
    use Mix.Project

    def project do    
      [app: :drop_app,     
       version: "0.0.1",     
       elixir: "~> 1.0.0-rc2",     
       deps: deps]  
    end
    # Configuration for the OTP application  
    #  
    # Type `mix help compile.app` for more information  
    def application do    
      [applications: [:logger]]  
    end

    # Dependencies can be Hex packages:  
    #  
    #   {:mydep, "~> 0.3.0"}  
    #  
    # Or git/path repositories:
    #  
    #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}  
    #  
    # Type `mix help deps` for more examples and options  
    defp deps do    
      []  
    end
  end
  ```
  - The project/0 function lets you name your application, give it a version number, and specify the dependencies for building the project.
  - In addition to git:, you may specify the location of a dependency as a local file (path:)
  - If you type the command mix compile, Mix will compile your empty project. If you look in your directory, you will see that Mix has created an _build directory for the compiled code.
  - start iex -S mix. Mix will compile the new files
  - If you type mix compile at the command prompt, Mix will generate a file _build/dev/lib/drop_app/ebin/drop_app.app. (If you look at that file, you will see an Erlang tuple that contains much of the information gleaned from the files you have already created.)
