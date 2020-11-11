1 Before you begin    

1.1 Why containers will take over the world  

1.1.1 Migrating apps to the cloud  
  - There used to be two options for migrating an app to the cloud: infrastructure as a service (IaaS) and platform as a service (PaaS).
  - Our choice was basically a compromise--choose PaaS and run a project to migrate all the pieces of your application to the relevant managed service from the cloud.
  - The original options for migrating to the cloud--use IaaS and run lots of inefficient VMs with high monthly costs, or use PaaS and get lower running costs but spend more time on the migration.
  - Docker offers a third option without the compromises.
  - Migrate each part of your application to a container, and then you can run the whole application in containers using Azure Kubernetes Service or Amazon’s Elastic Container Service, or on your own Docker cluster in the datacenter.

1.1.2 MODERNIZING LEGACY APPS
  - Monoliths work just fine in containers, but they limit your agility.
  - If the feature is part of a monolith built from millions of lines of code, you’ve probably had to sit through a two-week regression test cycle before you get to the release.
  - Docker is a great first step to modernizing the architecture
  - Containers run in their own virtual network, so they can communicate with each other without being exposed to the outside world.
  - Because of this you can start breaking up you applications and moving features into their own containers. Gradually your monolithic architecture can evolve into a distributed application with features being provided by multiple containers.

1.1.3 BUILDING NEW CLOUD-NATIVE APPS
  - Docker can help get applcations into the cloud whether they are monolithics or distributed applications.

1.1.4 TECHNICAL INNOVATION: SERVERLESS AND MORE
  - Serverless is all about containers.
  - The goal of serverless is for developers to write function code, push it to a service, and that service builds and packages the code.
  - When consumers use the function, the service starts an instance of the function to process the request. There are no build servers, pipelines, or production servers to manage; it’s all taken care of by the platform.
  - All the cloud serverless options use Docker to package the code and containers to run functions.

1.1.5 DIGITAL TRANSFORMATION WITH DEVOPS
  - DevOps aims to bring agility to software deployment and maintenance by having a single team own the whole application life cycle, combining “dev” and “ops” into one deliverable.
  - DevOps can take organizations from huge quarterly releases to small daily deployments.
  - There’s a powerful framework for implementing DevOps called CALMS--Culture, Automation, Lean, Metrics, and Sharing.

1.2 Is this book for you?
  - Kubernetes is just a different way of running Docker containers, so everything you learn in this book applies.
1.3 Creating your lab environment

1.3.1 INSTALLING DOCKER

1.3.2 VERIFYING YOUR DOCKER SETUP
  - docker version
  - docker-compose version

1.3.3 DOWNLOADING THE SOURCE CODE FOR THE BOOK

1.3.4 REMEMBERING THE CLEANUP COMMANDS
  - docker container rm -f $(docker container ls -aq)
  - docker image rm -f $(docker image ls -f reference=diamol/* -q)

1.4 Being immediately effective
