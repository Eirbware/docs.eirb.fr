MKDOCS_IMAGE := squidfunk/mkdocs-material:latest

MKDOCS := docker run --rm -u $(shell id -u) -v ./mkdocs:/docs $(MKDOCS_IMAGE)
MKDOCS_DEV := docker run --rm -u $(shell id -u) -v ./mkdocs:/docs -p 8000:8000 $(MKDOCS_IMAGE)

PHONY += all
all: build

PHONY += dev
dev:
	$(MKDOCS_DEV)

PHONY += build
build:
	$(MKDOCS) build

PHONY += start
start:
	python -m http.server 8080 -d mkdocs/site

PHONY += clean
clean:
	${RM} -r mkdocs/site

PHONY += mrproper
mrproper: clean
	docker rmi $(MKDOCS_IMAGE)

.PHONY: $(PHONY)
