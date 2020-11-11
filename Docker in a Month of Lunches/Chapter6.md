6 Using Docker volumes for persistent storage
  - You can meet increased demand by running multiple containers on your cluster, knowing that every container will handle requests in the same way.

6.1 Why data in containers is not permanent
  - A Docker container has a filesystem with a single disk drive, and the contents of that drive are populated with the files from the image.
  - The container’s disk is actually a virtual filesystem that Docker builds up by merging all the image layers together.
  - Docker doesn’t delete the container’s filesystem when it exits--it’s retained so you can still access files and folders.
  ```bash
  docker container cp
  ```
    - copy files between containers and local machine.
  - Stopping a container doesn’t automatically remove it, so a stopped container’s filesystem does still exist.
  - Docker uses a copy-on-write process to allow edits to files that come from read-only layers.
  - Modifying files in a container does not affect the image, and the container’s data is transient.
  - he virtual filesystem for the container is always built from image layers and the writeable layer, but there can be additional sources as well. Those are Docker volumes and mounts.

6.2 Running containers with Docker volumes
  - A Docker volume is a unit of storage.
  - Volumes exist independently of containers and have their own life cycles, but they can be attached to containers.
  - Volumes appear as a director in the container's filesystem.
  - The container writes data to the directory, which is actually stored in the volume.
  - There are two ways to use volumes with containers: you can manually create volumes and attach them to a container, or you can use a VOLUME instruction in the Dockerfile.
  - The syntax is simply VOLUME <target-directory>
  - Volumes declared in Docker images are created as a separate volume for each container, but you can also share volumes between containers.
  - You can run a container with the volumes-from flag, to share a container.
  - Volumes are better used to preserve state between application upgrades, and then it’s better to explicitly manage the volumes.
  - It is not a good idea to have containers share Volumes.
  - The VOLUME instruction in the Dockerfile and the volume (or v ) flag for running containers are not the same features.
  - Images built with a VOLUME instruction will always create a volume for a container if there is no volume specified in the run command and the volume will have a random ID. Therefore you must figure out what it was.
  - The volume flag mounts a volume into a container whether the image has a volume specified or not.
  - If the image does have a volume, the volume flag can override it for the container by using an existing volume for the same target path--so a new volume won’t be created.
  - You should not rely on defaults and work with named volumes.

6.3 Running containers with filesystem mounts
  - Volumes live on the host, so they are decoupled from containers.
  - More direct way of sharing between containers and hosts : bind mounts.
  - The bind mount is transparent to the container--it’s just a directory that is part of the container’s filesystem.
  - You can access host files from a container and vise versa.
  - The bind mount is bidirectional. You can create files in the container and edit them on the host, or create files on the host and edit them in the container.

6.4 Limitations of filesystem mounts
  - When you mount a target that already has data, the source directory replaces the target directory.
  - The container filesystem is one of the few areas where Windows containers are not the same as Linux containers.
  - You can not bind-mount a single file with Windows containers since te feature is not supported but you can in Linux.
  - Distributed filesystems let you access data from any machine on the network, and they usually use different storage mechanisms from your operating system’s local filesystem.
  - You can mount locations from distributed storage systems like these into a container. The mount will look like a normal part of the filesystem, but if it doesn’t support the same operations, your app could fail.
  - Understand that distributed storage will have very different performance characteristics from local storage.

6.5 Understanding how the container filesystem is built
  - Every container has a single disk, which is a virtual disk that Docker pieces together from several sources : UNION FILESYSTEM
  - Applications inside a container see a single disk, but as the image author or container user, you choose the sources for that disk.
  - General guidelines for how you should use the storage options:
    1. Writeable layer --Perfect for short-term storage, like caching data to disk to save on network calls or computations. Gone when container is removed.
    2. Local bind mounts --Used to share data between the host and the container. Developers can use bind mounts to load the source code on their computer into the container. Good for local changes so that the container loads it when there are updates without making a new image.
    3. Distributed bind mounts --Used to share data between network storage and containers. However may not offer full filesystem features.
    4. Volume mounts --Used to share data between the container and a storage object that is managed by Docker. Good for persistent storage for when you upgrade your app with a new container you can maintain the same data from previous version.
    5. Image layers --These present the initial filesystem for the container. Layers are stacked, with the latest layer overriding earlier layers, so a file written in a layer at the beginning of the Dockerfile can be overridden by a subsequent layer that writes to the same path. Can be shared between containers.
