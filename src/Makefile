# If we have `--squash` support, then use it!
ifneq ($(shell docker build --help 2>/dev/null | grep squash),)
DOCKER_BUILD = docker build --squash
else
DOCKER_BUILD = docker build
endif

all: build

build: Makefile Dockerfile
	$(DOCKER_BUILD) -t nualartlee/nginx-certbot .
	@echo "Done!  Use docker run nualartlee/nginx-certbot to run"

push:
	docker push nualartlee/nginx-certbot
