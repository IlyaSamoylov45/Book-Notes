2 Understanding Docker and running Hello World

2.1 Running Hello World in a container
  - docker container run diamol/ch02-hello-diamol
  - The docker container run command tells Docker to run an application in a container.
  - Docker needs to have a copy of the image locally before it can run a container using the image.
  - After it downloads the image Docker can start the container using said image.
  - The image contains all the content for the application, along with instructions telling Docker how to start the application.

2.2 So what is a container?
  - A Docker container is the same idea as a physical container--think of it like a box with an application in it.
  - Inside the box the application has its own machine name, network address and disk drive.
  - Windows containers have their own Window Registry as well.
  - The hostname, filesystem and IP address are all created by Docker and managed by it as well.
  - Multiple containers can run on an computer and have their own serperate environments.
  - All the containers share the CPU, OS memory of the computer.
  - By doing this is fixes two conflicting problems in computing: isolation and density.
  - Density means running as many applications on your computers as possible, to utilize all the processor and memory that you have.
  - The containers may use different tools.
  - Virtual machines are similar in concept to containers, in that they give you a box to run your application in, but the box for a VM needs to contain its own operating system.
  - VMs don't share the OS of the computer it's running on.
  - VMs provide isolation at the cost of density.
  - Containers unlike VMs give you both

2.3 Connecting to a container like a remote computer
  ```
  docker container run --interactive --tty diamol/base
  ```
  ```
  --interactive
  ```
   - flag tells Docker you want to set up a connection to the container
  ```
  --tty
  ```

  - flag means you want to connect to a terminal session inside the container.
  - What you have here is a local terminal session connected to a remote machine--the machine just happens to be a container that is running on your computer.
  - The container is sharing your computer’s operating system, which is why you see a Linux shell.
  -  It’s the application inside the container that sees it’s running on an Intel-based Windows machine or another.
  ```
  docker container ls
  ```
    - Details of all the running containers
    - The output shows you information about each container, including the image it’s using, the container ID, and the command Docker ran inside the container when it started--this is some abbreviated output.
  - Docker assigns a random ID to each container it creates. This is used as part of the ID used for hostname.
  ```
  docker container top
  docker container top e1
  Usage:  docker container top CONTAINER [ps OPTIONS]
  ```
    - Lists the processes running in the container. I’m using f1 as a short form of the container ID f1695de1f2ec
    - If you have multiple processes running in the container, Docker will show them all.
  ```
  docker container logs
  docker container logs [OPTIONS] CONTAINER
  docker container logs e1
  ```
    - Displays any log entries the container has collected
    - Docker collects log entries using the output from the application in the container. In the case of this terminal session
    - A web application may write a log entry for every HTTP request processed. These will show up in logs!
  ```
  docker container inspect
  Usage:  docker container inspect [OPTIONS] CONTAINER [CONTAINER...]
  docker container inspect e1
  ```
    - Shows you all the details of a container.
    - It comes as a large chunk of JSON, which is great for automating with scripts.
  - Docker adds a consistent management layer on top of every application.
  ```
  exit
  ```
    - closes the terminal session.

2.4 Hosting a website in a container
  ```
  docker container ls
  ```
    - Will show that you have no containers, because the command only shows running containers.
  ```
  docker container ls --all
  docker container ls --a
  docker container ls -a
  ```
    - docker container in any status
  - Containers are running only while the application inside the container is running.
  - Exited containers don’t use any CPU time or memory.
  - Containers in the exited state still exist, which means you can start them again, check the logs, and copy files to and from the container’s filesystem.
  - Exited Docker containers still take up disk space!
  - Docker doesn’t remove exited containers unless you explicitly tell it to do so.
  ```
  docker container run --detach --publish 8088:80 diamol/ch02-hello- diamol-web
  ```
    - example of running a website in container without shutting down.
    - traffic sent to the computer on port 8088 will get sent into the container on port 80
  -  Containers that sit in the background and listen for network traffic (HTTP requests in this case) need a couple of extra flags in the container run command:
  ```
  --detach
  ```
    - Starts the container in the background and shows the container ID
  ```
  --publish
  ```
    - Publishes a port from the container to the computer
  - When you install Docker, it injects itself into your computer’s networking layer.
  - Traffic coming into your computer can be intercepted by Docker, and then Docker can send that traffic into a container.
  ```
  docker container stats
  ```
    - shows a live view of how much CPU, memory, network, and disk the container is using.
  ```
  docker container rm
  docker container rm --force $(docker container ls --all --quiet)
  ```
    - you can remove a container
    - the force flag to force removal if the container is still running.

2.5 Understanding how Docker runs containers
  - The Docker Engine is the management component of Docker. It looks after the local image cache, downloading images when you need them, and reusing them if they’re already downloaded.
  - The Docker Engine makes all the features available through the Docker API, which is just a standard HTTP-based REST API.
  - The Docker command-line interface (CLI) is a client of the Docker API.
  - When you run Docker commands, the CLI actually sends them to the Docker API, and the Docker Engine does the work.
  - You can point your CLI to the API on a remote computer running Docker and control containers on that machine--that’s what you’ll do to manage containers in different environments, like your build servers, test, and production.

2.6 Lab: Exploring the container filesystem
  - The 'docker exec' command runs a new command in a running container.
  - 'docker container cp' to copy a local file into the container.
    - docker container cp index.html 86b:/usr/local/apache2/htdocs/index.html
