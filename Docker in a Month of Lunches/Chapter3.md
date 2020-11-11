3 Building your own Docker images

3.1 Using a container image from Docker Hub
  - 'docker container' run will download the container image locally if it isn’t already on your machine.
  - you can explicitly pull images using the Docker CLI.
  ```bash
  docker image pull diamol/ch03-web-ping

  ```
  - Docker Hub is the default location where Docker searches for images.
  - Image servers are called registries, like Docker Hub which is a free public registry.
  - During the pull you don’t see one single file downloaded; you see lots of downloads in progress. Those are called image layers.
  - A Docker image is physically stored as lots of small files, and Docker assembles them together to create the container’s filesystem.
  - The -d flag is a short form of --detach, container will run in the background.
  ```bash
  docker container run -d --name web-ping diamol/ch03-web-ping
  ```
  - Docker containers also have environment variables
  - You can specify different values for environment variables when you create the container, and that will change the behavior of the app.
  - The host computer has its own set of environment variables too, but they’re separate from the containers.
  - Each container only has the environment variables that Docker populates.

3.2 Writing your first Dockerfile
  - FROM --Every image has to start from another image.
  - ENV --Sets values for environment variables.
  - WORKDIR --Creates a directory in the container image filesystem, and sets that to be the current working directory.
  - COPY --Copies files or directories from the local filesystem into the container image. The syntax is [source path] [target path]
  - CMD --Specifies the command to run when Docker starts a container from the image.

3.3 Building your own container image
  - It needs a name for the image, and it needs to know the location for all the files that it’s going to package into the image.
  - The --tag argument is the name for the image

3.4 Understanding Docker images and image layers
  - The Docker image contains all the files you packaged, which become the container’s filesystem, and it also contains a lot of metadata about the image itself.
  ```bash
  docker image history web-ping
  ```
    - history for your web-ping image
  - The CREATED BY commands are the Dockerfile instructions--there’s a one-to-one relationship, so each line in the Dockerfile creates an image layer.
  - A Docker image is a logical collection of image layers.
    - Layers are the files that are physically stored in the Docker Engine’s cache.
    - Image layers can be shared between different images and different containers.
    - our web-ping image is based on diamol/node , so it starts with all the layers from diamol/node!
  - docker image ls
    - The size column you see is the logical size of the image--that’s how much disk space the image would use if you didn’t have any other images on your system.
    - The amount of disk space you save through reuse is typically much larger when you have a large number of application images all sharing the same base layers for the runtime.
  - If image layers are shared around, they can’t be edited otherwise a change in one image would cascade to all the other images that share the changed layer. 
    - Docker enforces that by making image layers read-only.

3.5 Optimizing Dockerfiles to use the image layer cache
  - Docker assumes the layers in a Docker image follow a defined sequence, so if you change a layer in the middle of that sequence, Docker doesn’t assume it can reuse the later layers in the sequence.
  - Docker calculates whether the input has a match in the cache by generating a hash
  - Any Dockerfile you write should be optimized so that the instructions are ordered by how frequently they change
    1. Optimize your Dockerfiles
    2. make sure your image is portable so you use the same image when you deploy to different environments.
