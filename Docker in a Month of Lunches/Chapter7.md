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
