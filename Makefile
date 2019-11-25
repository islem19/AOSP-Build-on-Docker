DOCKER = docker
IMAGE = sabdelkader/aosp

all: Dockerfile
		$(DOCKER) build -t $(IMAGE) .

.PHONY: all