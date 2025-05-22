# knowrob\_cram\_demo

A demonstration repository for running KnowRob with CRAM inside Docker.

## Overview

This project provides a Docker-based setup to launch a KnowRob-enabled CRAM planning environment. It includes:

* A Dockerfile to build the `knowrob_cram_demo` image.
* A ROS launch file (`knowrob.launch`) to start KnowRob and CRAM.
* Example Python scripts demonstrating CRAM plans.

## Prerequisites

* [Docker](https://www.docker.com/) installed on your machine.
* Internet connection to pull base images.

## Building the Docker Image

From the root of this repository, build the Docker image with:

```bash
docker build -t knowrob_cram_demo .
```

This will create a local image tagged `knowrob_cram_demo:latest`.

## Running the Docker Container

Start an interactive container named `knowrob_cram_demo`:

```bash
docker rm knowrob_cram_demo 2>/dev/null || true && \
  docker run -it --name knowrob_cram_demo \
    --entrypoint bash knowrob_cram_demo:latest
```

This command will remove any existing container with the same name and launch a new one, dropping you into a Bash shell inside the container.

## Launching KnowRob & CRAM

Inside the container's Bash shell, start ROS and KnowRob with:

```bash
roslaunch knowrob_cram_demo knowrob.launch
```

This will initialize the ROS core, load KnowRob, and bring up the CRAM planning environment.

## Executing a CRAM Plan

Open a second terminal on your host machine and enter the running container shell:

```bash
docker exec -it knowrob_cram_demo bash
```

From inside the container prompt, run one of the example CRAM plans. For instance:

```bash
python3 src/knowrob_cram_demo/scratch_3.py
```
