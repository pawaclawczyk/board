ifeq (Boot2Docker, $(findstring Boot2Docker, $(shell docker info)))
	PLATFORM := OSX
else
	PLATFORM := Linux
endif

ifeq ($(PLATFORM), OSX)
	CONTAINER_HOME = /root
	RUN_AS =
else
	GROUP_ID = $(shell id -g)
	USER_ID  = $(shell id -u)
	CONTAINER_USERNAME  = dummy
	CONTAINER_GROUPNAME = dummy
	CONTAINER_HOME = /home/$(CONTAINER_USERNAME)

	RUN_AS = \
	  groupadd -f -g $(GROUP_ID) $(CONTAINER_GROUPNAME) && \
	  useradd -u $(USER_ID) -g $(CONTAINER_GROUPNAME) $(CONTAINER_USERNAME) && \
	  mkdir --parent $(CONTAINER_HOME) && \
	  chown -R $(CONTAINER_USERNAME):$(CONTAINER_GROUPNAME) $(CONTAINER_HOME) && \
	  sudo -u $(CONTAINER_USERNAME)
endif

ifeq (composer-run, $(firstword $(MAKECMDGOALS)))
	COMPOSER_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(COMPOSER_ARGS):;@:)
endif

ifeq (board-run, $(firstword $(MAKECMDGOALS)))
	BOARD_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
    $(eval $(BOARD_ARGS):;@:)
endif

PROJECT_NAME         = board
ROOT_DIR             = $(PWD)

DOCKER_DIR           = $(ROOT_DIR)/docker
PHP_IMAGE            = $(PROJECT_NAME)/php

PHP_SOURCE_DIR       = $(ROOT_DIR)

CONATINER_WORKDIR    = /board
MOUNT_COMPOSER_CACHE = -v $(HOME)/.composer:$(CONTAINER_HOME)/.composer
MOUNT_PHP_SOURCE     = -v $(PHP_SOURCE_DIR):$(CONATINER_WORKDIR)

PHP_RUN          = docker run --rm -ti $(MOUNT_PHP_SOURCE) $(MOUNT_PHP_SOURCE) -w $(CONATINER_WORKDIR) $(PHP_IMAGE)

build-image:
	docker build -t $(PHP_IMAGE) $(DOCKER_DIR)

board-run: build-image
	$(PHP_RUN) \
	  bash -c '$(RUN_AS) $(BOARD_ARGS)'

composer-run: build-image
	$(PHP_RUN) \
	  bash -c '$(RUN_AS) composer $(COMPOSER_ARGS)'
