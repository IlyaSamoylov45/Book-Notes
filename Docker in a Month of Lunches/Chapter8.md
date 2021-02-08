8 Supporting reliability with health checks and dependency checks
  - In production you’ll run your apps in a container platform like Docker Swarm or Kubernetes, and those platforms have features that help you deploy self-healing apps.

8.1 Building health checks into Docker images
  - Docker monitors the health of your app at a basic level every time you run a container.
  - Docker gives you a neat way to build a real application health check right into the Docker image, just by adding logic to the Dockerfile.
  - Enter the HEALTHCHECK instruction, which you can add to a Dockerfile to tell the runtime exactly how to check whether the app in the container is still healthy.
  - The HEALTHCHECK instruction specifies a command for Docker to run inside the container, which will return a status code--the command can be anything you need to check if your app is healthy.
  - Unhealthy status is published as an event from Docker’s API, so the platform running the container is notified and can take action to fix the application. Docker also records the result of the most recent health checks, which you can see when you inspect the container.
  - Health checks become really useful in a cluster with multiple servers running Docker being managed by Docker Swarm or Kubernetes.

8.2 Starting containers with dependency checks
  - You can add that dependency check inside the Docker image. A dependency check is different from a health check--it runs before the application starts and makes sure everything the app needs is available.

8.3 Writing custom utilities for application check logic
  - Although curl is a great tool for getting started with container checks, it’s better to write a custom utility for your checks using the same language that your application uses--Java for Java apps, Node.js for Node.js apps, and so on.

8.4 Defining health checks and dependency checks in Docker Compose
  - You have fine-grained control over the health check.
    1. interval is the time between checks
    2. timeout is how long the check should be allowed to run before it’s considered a failure.
    3. retries is the number of consecutive failures allowed before the container is flagged as unhealthy.
    4. start_period is the amount of time to wait before triggering the health check, which lets you give your app some startup time before health checks run.
  -  Compose can only manage dependencies on a single machine, and the startup behavior of your app on a production cluster is far less predictable.

8.5 Understanding how checks power self-healing apps
  - The idea of self-healing apps is that any transient failures can be dealt with by the platform. 
