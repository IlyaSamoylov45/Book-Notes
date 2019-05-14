Chapter 3. Processes 101
  - Erlang VM supports 134 million processes!
  - The processes created by Erlang VM are independent of the OS; they're lighter weight and take microseconds to create.

3.1. Actor concurrency model
  - Erlang (and Elixir) uses the Actor concurrency model. Meaning:
    1. Each actor is a process.
    2. Each process performs a specific task.
    3. To tell a process to do something, you need to send it a message. The process can reply by sending back another message.
    4. The kinds of messages the process can act on are specific to the process itself. In other words, messages are pattern-matched.
    5. Other than that, processes don’t share any information with other processes.
  - The actor concurrency model like people, responds only to certain kinds of messages.

3.2 Building a weather application
  - One of the properties of concurrency is that you never know the order of the responses.

3.2.1. The naïve version
  -
