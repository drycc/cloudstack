CODENAME           ?= bookworm
APT_MIRROR         ?= mirrors.cloud.tencent.com
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
	scripts/prepare-management.sh

clean:
	@rm -rf mysql/logs/*
	@rm -rf mysql/data/*
	@rm -rf management/data/root/*
	@rm -rf management/data/etc/default/cloudstack/*
	@rm -rf nfs-server/data/exports/{primary,secondary}/*
