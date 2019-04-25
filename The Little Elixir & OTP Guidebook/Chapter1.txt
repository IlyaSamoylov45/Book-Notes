Chapter 1. Introduction
  - Erlang is a programming language that excels in building soft real-time, distributed, and concurrent systems.
  - Erlang VM’s scheduler automatically distributes workloads across processors.

Chapter 1.1. Elixir
  - OTP used to be an acronym for Open Telecom Platform
  - Meta-programming involves code that generates code

Chapter 1.2. How is Elixir different from Erlang?
  - Both Elixir and Erlang compile down to the same bytecode.

Chapter 1.2.1. Tooling
  - iex: this tool allows you to connect to nodes
  - The IEx.pry line will cause the interpreter to pause, allowing you to inspect the variables that have been passed in.
  - Built-in test framework called ExUnit. ExUnit has some useful features such as being able to run asynchronously and produce beautiful failure messages
  - mix is a build tool used for creating, compiling, and testing Elixir projects.
  - Streams are basically composable, lazy enumerables.
  - Macros are used to extend the Elixir language by giving it new constructs expressed in existing ones.

Chapter 1.2.2. Ecosystem
  - Built on Erlang so can use libraries

Chapter 1.3. Why Elixir and not X?
  - New language that's still evolving

Chapter 1.4. What is Elixir/OTP good for?
  - Everything that Erlang is great for also applies to Elixir.
  - Elixir and OTP combined provide facilities to build concurrent, scalable, fault-tolerant, distributed programs.
  - Not really meant for: image processing, perform computationally intensive tasks, or build GUI applications on Elixir.

Chapter 1.5. The road ahead

Chapter 1.5.1. A sneak preview of OTP behaviors
  - Behaviors care important in OTP and can be thought of as a contract between you and the OTP
  - OTP takes care of a slew of issues such as:
    1. message handling (synchronous or asynchronous)
    2. concurrency errors (deadlocks and race conditions)
    3. fault tolerance
    4. failure handling

Chapter 1.5.2. Distribution for load balancing and fault tolerance
  - Elixir is good for distributed systems.
  - One reason to build a distributed application is to spread the load across multiple computers.

Chapter 1.5.3. Dialyzer and type specifications
  - Elixir is a dynamic language

Chapter 1.5.4. Property and concurrency testing
  - QuickCheck for property-based testing and how property-based testing
  - Concuerror reveals hard-to-detect concurrency bugs such as deadlocks and race conditions.
