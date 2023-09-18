CODENAME           ?= bookworm
AGENT_IP           ?= 127.0.0.1
APT_MIRROR         ?= mirrors.cloud.tencent.com
DOCKER_MIRROR      ?= https://mirrors.aliyun.com/docker-ce/linux/ubuntu
UBUNTU_VERSION     ?= 22.04
CLOUDSTACK_VERSION ?= 4.18.1


up:
	docker-compose --env-file environment up -d

down:
	docker-compose --env-file environment down

build:
	docker-compose --env-file environment build --build-arg CODENAME=$(CODENAME) --build-arg APT_MIRROR=$(APT_MIRROR) --build-arg UBUNTU_VERSION=$(UBUNTU_VERSION) --build-arg CLOUDSTACK_VERSION=$(CLOUDSTACK_VERSION)

prepare-agent:
	CLOUDSTACK_VERSION=$(CLOUDSTACK_VERSION) scripts/prepare-agent.sh

prepare-management:
	DOCKER_MIRROR=$(DOCKER_MIRROR) scripts/prepare-management.sh

clean:
	@rm -rf mysql/logs/*
	@rm -rf mysql/data/*
	@rm -rf management/data/root/*
	@rm -rf management/data/etc/default/cloudstack/*
	@rm -rf nfs-server/data/exports/{primary,secondary}/*
