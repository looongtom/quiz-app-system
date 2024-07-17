# Step 1: Set the base image
FROM eclipse-temurin:17-alpine as build

# Step 2: Set the working directory in the Docker image filesystem
WORKDIR /workspace/app

# Step 3: Copy the project files to the working directory
COPY target/demo-0.0.1-SNAPSHOT.jar app/demo-0.0.1-SNAPSHOT.jar

# Step 8: Specify the entry point
ENTRYPOINT ["java","-jar","app/demo-0.0.1-SNAPSHOT.jar"]