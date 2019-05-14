Chapter 9 Playing with Processes

The Shell Is a Process
  - The first thing to explore is the process identifier, often called a pid.
  - self() gets your pid.
  - self() will return three integers which provide a unique identifier for this process.
  - elixir will never report that a message send failed even if pid doesn't point to a real process.
  - To send message use the send/2 function with two arguments: a function or variable containing the pid and the message.
  - flush() to see mailbox but also flushes it.
  - The proper way to read the mailbox is the receive_end construct

Spawning Processes from Modules
  - To create a process that keeps processing messages, you need to add a recursive call

Lightweight Processes

Registering a Process
  - Elixir provides a process registration system that is extremely simple: you specify an atom and a pid, and then any process that wants to reach that registered process can just use the atom to find it.
  - To register a process, just use the Process.register/2 built-in function. The first argument is the pid of the process, and the second argument is an atom
  - If you attempt to call a process that doesn’t exist (or one that has crashed), you’ll get a bad arguments error
  - If you attempt to register a process to a name that is already in use, you’ll also get an error, but if a process has exited (or crashed), the name is effectively no longer in use and you can re-register it.
  - Remember that you must use an atom for the process name.
  - You can also use Process.whereis/1 to retrieve the pid for a registered process (or nil, if there is no process registered with that atom)
  - unregister/1 to take a process out of the registration list without killing it.

When Processes Break

Processes Talking Amongst Themselves

Watching Your Processes
  - Observer, the process manager, offers a GUI that lets you look into the current state of your processes and see what’s happening.
  - The Observer will update the process list every ten seconds.

  ```Elixir
  iex(6)> :observer.start
  #PID<0.49.0>
  ```

Breaking Things and Linking Processes
  - Messages that don’t match a pattern in the receive clause don’t vanish; they just linger in the mailbox without being processed. It is possible to update a process with a new version of the code that retrieves those messages.
  - You can call a linked process from a process so failures propagate
  - Links are bidirectional.
  - Building applications that can tolerate failure and restore their functionality is at the core of robust Elixir programming.
  
