## dcape-app-template Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= dendrite

#- The domain name of this homeserver.
APP_DOMAIN         ?= dev.test

#- Hostname for external access
APP_SITE           ?= matrix.$(APP_DOMAIN)

#- app root
APP_ROOT           ?= $(PWD)

#- Docker image name
IMAGE              ?= ghcr.io/matrix-org/dendrite-monolith

#- Docker image tag
IMAGE_VER          ?= v0.13.6

USE_DB              = yes

# Default username for create-user-admin
APP_USER           ?= admin

# ------------------------------------------------------------------------------

# if exists - load old values
-include $(CFG_BAK)
export
-include $(CFG)
export

# ------------------------------------------------------------------------------
# Find and include DCAPE_ROOT/Makefile
DCAPE_COMPOSE   ?= dcape-compose
DCAPE_ROOT      ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
else
  include /opt/dcape/Makefile.app
endif

# ------------------------------------------------------------------------------

.default-deploy: init-files

## create required files
init-files: $(APP_ROOT)/config $(APP_ROOT)/config/matrix_key.pem $(APP_ROOT)/config/dendrite.yaml

$(APP_ROOT)/config:
	mkdir -p $@

$(APP_ROOT)/config/matrix_key.pem: CMD=run --rm --entrypoint="" app /usr/bin/generate-keys -private-key /etc/dendrite/matrix_key.pem -tls-cert /etc/dendrite/server.crt -tls-key /etc/dendrite/server.key
$(APP_ROOT)/config/matrix_key.pem: dc

$(APP_ROOT)/config/matrix_key.pem11:
	@docker run --rm --entrypoint="" \
	  -v $(DCAPE_ROOT)/$(DATA_PATH)/config:/mnt \
	  $${IMAGE}:$${IMAGE_VER} \
	  /usr/bin/generate-keys \
	  -private-key /mnt/matrix_key.pem \
	  -tls-cert /mnt/server.crt \
	  -tls-key /mnt/server.key

$(APP_ROOT)/config/dendrite.yaml: dendrite-sample.monolith.yaml
	@sed "s/server_name: localhost/server_name: $(APP_DOMAIN)/ ; s|postgresql://username:password\@hostname/dendrite|postgresql://$(PGUSER):$(PGPASSWORD)\@db/$(PGDATABASE)|" $<  > $@

## create admin user
create-user-admin: CMD=exec -it app /usr/bin/create-account -config /etc/dendrite/dendrite.yaml -username $(APP_USER) -admin
create-user-admin: dc

## show create help
create-user-admin-help: CMD=exec -it app /usr/bin/create-account -h
create-user-admin-help: dc

## show versions
check:
	curl http://$(APP_SITE)/_matrix/client/versions
