# Personal Stable Diffusion Web UI Docker
Privacy focused local docker environment for Stable Diffusion Web UIs with offline mode support and easy access to files.

## Features
- Easy to install, setup and launch
- Support for original **Stable Diffusion Web UI** and forks like **Forge** / **reForge**
- Offline mode, prevents the container from accessing the internet, while still allowing access to the webui
- Source code and data stored in your local filesystem and mounted using bind, no extra volumes

## Prerequisites

  - Cuda / Nvidia GPU
  - Linux or [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install)
  - [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Recommended) **OR** [Docker](https://docs.docker.com/engine/install/) + [Docker Compose plugin](https://docs.docker.com/compose/install/)


## Installation

Clone or download this repository into your Linux or WSL distro.

Launch the setup script using either `a1111`, `forge` or `reforge` as parameter, for example:
 ```bash
 bash setup.sh forge
 ```

Next, run the build script to build the docker images:
```bash
./build-docker-images.sh
```

Finally, execute the run script to complete the setup:
```bash
./run-with-internet.sh
```

Once the webui has finished downloading and you have made sure it works properly, the offline mode can be used for increased security:
```
./run-offline.sh
```

Note that some actions like **interrogate clip** may require online access the first time to download all the models and other requirements. 

Installing and updating extensions will naturally also require launching with internet:
```bash
./run-with-internet.sh
```

## Usage

### Accessing the webui
The webui is accessible from your browser through:
```
http://localhost:7860/
```

### Switching to another webui fork
To switch to another webui fork, run `./setup.sh` again.

When switching to a new webui for the first time, you must launch with internet to complete the installation:

```bash
./run-with-internet.sh
```

## Future Plans

- Add update script (git pull)
- Add support for additional SD WebUI forks
- Add template for binding directories like models and output
- Shadow mode for more privacy when updating webui with internet connection
- Add read only protection for webui source code directories
- Support for other GPUs

- Create a WSL and Docker Desktop setup guide
- Create similar repos for other UIs

## Technical Overview

### Offline mode

In offline mode, the webui container is only allowed to communicate with other containers inside a docker internal network. An additional "tunnel" container is created which has access to both the external and internal docker networks. The tunnel simply listens to the port where the webui would normally reside on the external network and forwards the traffic to the webui container on the internal network.

When running in offline mode, a communication attempt with the outside world is performed during startup. The webui container tries to ping the Google DNS server at 8.8.8.8, which should never succeed in this mode. If it does succeed, the webui container simply aborts the launch.

### Bind mounts

The external webui directory is mounted into the container with a bind mount, this means you can access easily access and modify all source code and data from outside the container. 

To make sure files and directories created inside the container gets the proper external user id, the id of your external user is set in the `user.env` file as the `setup.sh` script runs. Your external user id is then read from the `user.env` during container startup and set for the `ubuntu` user inside the container.

The users home directory is mounted into the `<webui>/cache/home` of the repo and tmpdir is mounted into `<webui>/tmp` of the repo.
