# Jupyter Environment for Scientific Notebook & AI Research

This repository provides a Docker-based Jupyter environment specialized for scientific computing and AI research, equipped with PyTorch with CUDA 12.1 and Julia.

## Owner

- **Username:** yspkm
- **Email:** [yosepkim@snu.ac.kr](mailto:yosepkim@snu.ac.kr)

## Features

- **PyTorch 2.2.0** with CUDA 12.1 and cuDNN 8 support for high-performance GPU acceleration.
- **Julia** environment tailored for scientific computing.
- Easy to use and deploy with Docker.
- Licensed under **GPL-3.0**, ensuring freedom to share and modify the software while ensuring it remains free.

## Getting Started

### Prerequisites

- Docker installed on your system
- NVIDIA Docker runtime for GPU support

### Build

To build the Docker image, run the following command in the terminal:

```bash
make build
```

This command reads environment variables from the `.env` file and builds a Docker image with the specified PyTorch and CUDA versions.

### Run

To start the Jupyter Lab server:

```bash
make up
```

This command runs the container in detached mode, forwarding the necessary ports, and mounts your home directory (`/home/yosepkim`) to `/workspace` within the container.

### Stop

To stop and remove the running container:

```bash
make down
```

### Clean

To remove the Docker image:

```bash
make clean
```

### Help

To view available commands:

```bash
make help
```

This will output:

```bash
Available commands:
  make build    - Build the Docker image.
  make up       - Run the Docker container.
  make down     - Stop and remove the Docker container.
  make clean    - Remove the Docker image.
  make help     - Display this help message.
```


## How to Use

Once the container is up, access the Jupyter Lab interface by navigating to `http://<ip address>:8888` in your web browser. The environment is pre-configured with PyTorch and Julia for scientific notebook and AI research purposes.

`Font 위치: /usr/share/fonts/truetype/nanum/*.ttf`

## License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.