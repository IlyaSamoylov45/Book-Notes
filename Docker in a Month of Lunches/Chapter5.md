5 Sharing images with Docker Hub and other registries

5.1 Working with registries, repositories, and image tags
  - The server that stores images centrally is called a Docker registry.
  - Docker Hub is the first place Docker searches for an image.
  - There are four parts to a full image name (which is properly called the image reference).
    0. [docker.io/][diamol]/[golang]:[latest]
    1. The domain of the registry where the image is stored. (Default Dockerhub)
    2. The account of the image owner. Individual or org.
    3. The image repository name, used for the application name. One rep can store many versions of an image.
    4. The image tag, used for versioning or variations of an application. Latest is the default.
  - When you share images on a registry you must add additional details since the image reference is unique identifier for one specific image on a registry.
  - Docker uses a couple of defaults if you don’t provide values for parts of the image reference. The default registry is Docker Hub, while the default tag is latest .
  - Large companies usually have their own Docker registry in their own cloud environment or their local network.
  - When you start building your own application images, you should always tag them.
  - Tags are used to identify different versions of the same application.
  - Latest is used by default. Even if it may not be the latest.

5.2 Pushing your own images to Docker Hub
  - You need to do two things to push an image to a registry.
    1. Log in so that Docker knows your account is authorized to push images.
    2. Then you need to give your image a reference that includes the name of an account where you have permission to push.
  - To login to DockerHub :
  ```bash
  docker login --username $dockerId
  ```
  - To tag an image to be pused to  DockerHub :
  ```
  docker image tag image-gallery {username}/image-gallery:v1
  ```
  - The fact that registries work with image layers is another reason why you need to spend time optimizing your Dockerfiles.
  - Optimized Dockerfiles reduce build time, disk space, and network bandwidth.
  - That’s all there is to pushing images. Docker Hub creates a new repository for an image if it doesn’t already exist, and by default that repository has public read rights. Now anyone can find, pull, and use your image-gallery application. 

5.3 Running and using your own Docker registry

5.4 Using image tags effectively

5.5 Turning official images into golden images
  - Golden images use an official image as the base and then add in whatever custom setup they need, such as installing security certificates or configuring default environment settings.
