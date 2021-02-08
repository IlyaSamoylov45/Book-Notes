7 Running multi-container apps with Docker Compose
  - Docker is ideally suited to running distributed applications--from n-tier monoliths to modern microservices.

7.1 The anatomy of a Docker Compose file
  - The Docker Compose file describes the desired state of your app--what it should look like when everything’s running.
  - Spaces are important in YAML--indentation is used to identify objects and the child properties of objects.
  - version is the version of the Docker Compose format used in this file.
  - services lists all the components that make up the application.
  - networks lists all the Docker networks that the service containers can plug into.
  - You manage apps with Docker Compose using the docker-compose command line which is separate from the Docker CLI.

7.2 Running a multi-container application with Compose
  - Compose is a separate command-line tool for managing containers, but it uses the Docker API in the same way that the Docker CLI does.
  - The down command removes the application, so Compose stops and removes containers--it would also remove networks and volumes if they were recorded in the Compose file and not flagged as external .

7.3 How Docker plugs containers together
  - Docker also supports service discovery with DNS.
  - The DNS service in Docker performs that lookup--if the domain name is actually a container name, Docker returns the container’s IP address.
  - nslookup is a small utility that is part of the base image for the web application--it performs a DNS lookup for the name you provide, and it prints out the IP address.
  - To try to provide load-balancing across all the containers, the Docker DNS returns the list in a different order each time. It’s a basic way of trying to spread traffic around all the containers.

7.4 Application configuration in Docker Compose
  - Secrets are usually provided by the container platform in a clustered environment--that could be Docker Swarm or Kubernetes. They are stored in the cluster database and can be encrypted, so they’re useful for sensitive configuration data like database connection strings, certificates, or API keys.
  - On a single machine running Docker, there is no cluster database for secrets, so with Docker Compose you can load secrets from files.

7.5 Understanding the problem Docker Compose solves
  - The Compose file is simple and it’s actionable--you use it to run your app, so there’s no risk of it going out of date.
  - Compose lets you define your application and apply the definition to a single machine running Docker. 
