Chapter 1 First Steps

1.1 About Erlang

1.1.1 High availability
  - Erlang was specifically created to support the development of highly available systems ones always online even during unexpected circumstances
    1. Fault-tolerance — A system has to keep working when something unforeseen happens.
    2. Scalability — A system should be able to handle any possible load.
    3. Distribution — To make a system that never stops, you have to run it on multiple machines.
    4. Responsiveness — It goes without saying that a system should always be reasonably fast and responsive.
    5. Live update — In some cases, you may want to push a new version of your software without restarting any servers.

1.1.2 Erlang concurrency
  - Erlang VM (BEAM) uses its own schedulers to distribute the execution of processes over the available CPU cores
    1. Fault-tolerance : Erlang processes are completely isolated from each other.
    2. Scalability : Sharing no memory, processes communicate via asynchronous messages.
    3. Distribution : Communication between processes works the same way no matter where it is
    4. Responsiveness : The runtime is specifically tuned to promote the overall responsiveness of the system.

1.1.3 Server-side systems
  - It can run in-process C code and can communicate with practically any external component such as message queues, in-memory key/value stores, and external databases.

1.1.4 The development platform
  - OTP is a general-purpose framework that abstracts away many typical Erlang tasks

1.2 About Elixir

1.2.1 Code simplification
  - Elixir retains a 1:1 semantic relation to the underlying Erlang library that’s used to create server processes.
  - A macro is Elixir code that runs at compile time.
  - Due to its macro support and smart compiler architecture, most of Elixir is written in Elixir.

1.2.2 Composing functions
  - Elixir gives you an elegant way to chain multiple function calls together

1.2.3 The big picture

1.3 Disadvantages

1.3.1 Speed
  - The goal of the platform isn’t to squeeze out as many requests per second as possible, but to keep performance predictable and within limits.
  - As the load increases, BEAM can use as many hardware resources as possible. If the hardware capacity isn’t enough, you can expect graceful system degradation — requests will take longer to process, but the system won’t be paralyzed.
  - If most of your system’s logic is heavily CPU-bound, you should probably consider some other technology.

1.3.2 Ecosystem
  - The ecosystem built around Erlang isn’t small, but it definitely isn’t as big as that of some other languages.
