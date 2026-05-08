.PHONY: build-amd64 build-arm64 build-x86 build-all \
	archive-amd64 archive-arm64 archive-x86 archive-all push all

IMAGENAME ?= netshoot
VERSION ?= 0.1
DIST_DIR ?= dist
IMAGE_REF := $(IMAGENAME):$(VERSION)
ARCHIVE_PREFIX := $(IMAGENAME)-$(VERSION)

.DEFAULT_GOAL := archive-all

build-amd64:
	@docker buildx build --platform linux/amd64 --load -t $(IMAGE_REF) .

build-arm64:
	@docker buildx build --platform linux/arm64 --load -t $(IMAGE_REF) .

build-x86: build-amd64

build-all:
	@docker buildx build --platform linux/amd64,linux/arm64 --output type=image,push=false --file ./Dockerfile .

archive-amd64:
	@mkdir -p $(DIST_DIR)
	@docker buildx build --platform linux/amd64 --load --tag $(IMAGE_REF) .
	@docker save --output $(DIST_DIR)/$(ARCHIVE_PREFIX)-linux-amd64.tar $(IMAGE_REF)
	@gzip -f $(DIST_DIR)/$(ARCHIVE_PREFIX)-linux-amd64.tar

archive-arm64:
	@mkdir -p $(DIST_DIR)
	@docker buildx build --platform linux/arm64 --load --tag $(IMAGE_REF) .
	@docker save --output $(DIST_DIR)/$(ARCHIVE_PREFIX)-linux-arm64.tar $(IMAGE_REF)
	@gzip -f $(DIST_DIR)/$(ARCHIVE_PREFIX)-linux-arm64.tar

archive-x86: archive-amd64

archive-all: archive-amd64 archive-arm64

push:
	@docker push $(IMAGE_REF)

all: archive-all
