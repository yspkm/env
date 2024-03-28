IMAGE=yspkm/jupyter
TAG=huggingface/transformers-pytorch-gpu:4.35.2
DOCKERFILE=.
WORKDIR=/home/yspkm/work
CONTAINER=jupyter
ENVFILE=.env
SHELL=/bin/bash
BIN=/usr/bin

build:
	@args=""; \
	while IFS='=' read -r key value; do \
		if [ -n "$$key" ] && [ -n "$$value" ]; then \
			args="$$args --build-arg $$key=$$value"; \
		fi; \
	done < $(ENVFILE); \
	docker image build -t $(IMAGE):$(TAG) $$args $(DOCKERFILE)

up:
	docker container run \
		--restart=unless-stopped \
		--detach \
		--interactive \
		--tty \
		--runtime=nvidia \
		--shm-size=512g \
		--gpus all \
		--ipc=host \
		--volume $(WORKDIR):/workspace \
		-p 8888:8888 \
		-p 6006 \
		--name $(CONTAINER) \
		$(IMAGE):$(TAG) jupyter lab --allow-root

down:
	docker container stop $(CONTAINER)
	docker container rm $(CONTAINER)

clean:
	docker image rm $(IMAGE):$(TAG)

help:
	@echo "Available commands:"
	@echo "  make build    - Build the Docker image."
	@echo "  make up       - Run the Docker container."
	@echo "  make down     - Stop and remove the Docker container."
	@echo "  make clean    - Remove the Docker image."
	@echo "  make help     - Display this help message."
