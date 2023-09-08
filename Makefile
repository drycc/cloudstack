CODENAME        ?= bookworm
APT_MIRROR      ?= mirrors.cloud.tencent.com


up:
	docker-compose --env-file environment up -d

build:
	docker-compose build  --build-arg CODENAME=$(CODENAME) --build-arg APT_MIRROR=$(APT_MIRROR)

clean:
	@rm -rf mysql/logs/*
	@rm -rf mysql/data/*
	@rm -rf management/data/etc/default/cloudstack/*
	@rm -rf nfs-server/data/exports/{primary,secondary}/*
