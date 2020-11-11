4 Packaging applications from source code into Docker Images
  - You can also run commands inside Dockerfiles.
  - Commands execute during the build, and any filesystem changes from the command are saved in the image layer.

4.1 Who needs a build server when you have a Dockerfile?
  - You can write a Dockerfile that scripts the deployment of all your tools, and build that into an image. Then you can use that image in your application Dockerfiles to compile the source code, and the final output is your packaged application.
  - You can have multi-stage Dockerfiles
  - Each stage starts with a FROM instruction, and you can optionally give stages a name with the AS parameter.
  - At the end of the multistage process there will be only one docker image.
  - Each stage runs independently, but you can copy files and directories from previous stages.
  - COPY instruction with the --from argument tells Docker to copy files from an earlier stage in the Dockerfile, rather than from the filesystem of the host computer.
  - If a command fails at any stage the whole build will fail as well.

4.2 App walkthrough: Java source code
  - This is useful for uploading java code in the future:
  ```
  FROM diamol/maven AS builder

  WORKDIR /usr/src/iotd
  COPY pom.xml .
  RUN mvn -B dependency:go-offline

  COPY . .
  RUN mvn package

  # app
  FROM diamol/openjdk

  WORKDIR /app
  COPY --from=builder /usr/src/iotd/target/iotd-service-0.1.0.jar .

  EXPOSE 80
  ENTRYPOINT ["java", "-jar", "/app/iotd-service-0.1.0.jar"]
  ```
  - The ENTRYPOINT instruction is an alternative to the CMD instruction--it tells Docker what to do when a container is started from the image, in this case running Java with the path to the application JAR.
  - Containers access each other across a virtual network, using the virtual IP address that Docker allocates when it creates the container.
  ```bash
  docker network create nat
  ```
  - Now when you run containers you can explicitly connect them to that Docker network using the --network flag.
  - Anything you want from previous stages needs to be explicitly copied in that final stage.

4.3 App walkthrough: Node.js source code
  - Multistage docker with interpreted languages is beneficial because it optimized dependency loading.

4.4 App walkthrough: Go source code
  - Go compiles to native binaries, so each stage in the Dockerfile uses a different base image.
  - Multi-stage Dockerfiles make your project entirely portable.

4.5 Understanding multi-stage Dockerfiles
  - The first point is about standardization.
  - The second point is performance.
  - The final point is that multi-stage Dockerfiles let you fine-tune your build so the final application image is as lean as possible. 
