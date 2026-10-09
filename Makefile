SHELL := /bin/bash

DEFAULT_GOAL := help
.DEFAULT_GOAL := $(DEFAULT_GOAL)

PYTHON ?= python3
VENV := .
VENV_PYTHON := bin/python
VENV_PIP := bin/pip
BUILDOUT := bin/buildout
INSTANCE := bin/instance
TEST_RUNNER := bin/test
REQUIREMENTS := requirements-6.2.txt
SECRETS_EXAMPLE := secrets.example.cfg
SECRETS_LOCAL := secrets.local.cfg

.PHONY: help secrets venv setup buildout fg start stop restart status test build-js clean-js clean-all

help:
	@echo "Available targets:"
	@echo "  make secrets   Copy $(SECRETS_EXAMPLE) to $(SECRETS_LOCAL) if needed"
	@echo "  make venv      Create the project-root virtualenv and install buildout requirements"
	@echo "  make setup     Prepare local secrets, create the project-root virtualenv, and run buildout"
	@echo "  make buildout  Run buildout"
	@echo "  make fg        Run the Plone instance in foreground"
	@echo "  make start     Start the Plone instance in background"
	@echo "  make stop      Stop the Plone instance"
	@echo "  make restart   Restart the Plone instance"
	@echo "  make status    Show instance status"
	@echo "  make test      Run the test suite"
	@echo "  make build-js  Build all JS/CSS packages (tinymce, assistant)"
	@echo "  make clean-js  Remove built JS/CSS artifacts from all packages"
	@echo "  make clean-all Remove generated buildout state and the project-root virtualenv"

secrets:
	@if [ -f "$(SECRETS_LOCAL)" ]; then \
		echo "$(SECRETS_LOCAL) already exists"; \
	else \
		cp "$(SECRETS_EXAMPLE)" "$(SECRETS_LOCAL)"; \
		echo "Created $(SECRETS_LOCAL) from $(SECRETS_EXAMPLE)"; \
		echo "Edit $(SECRETS_LOCAL) before running the instance"; \
	fi

venv:
	@if [ ! -x "$(VENV_PYTHON)" ]; then \
		"$(PYTHON)" -m venv "$(VENV)"; \
	fi
	"$(VENV_PIP)" install -r "$(REQUIREMENTS)"

setup: secrets venv buildout

buildout: venv
	@if [ ! -f "$(SECRETS_LOCAL)" ]; then \
		echo "Missing $(SECRETS_LOCAL). Run 'make secrets' first."; \
		exit 1; \
	fi
	mkdir -p bin parts develop-eggs var
	$(BUILDOUT)

fg:
	@if [ ! -f "$(SECRETS_LOCAL)" ]; then \
		echo "Missing $(SECRETS_LOCAL). Run 'make secrets' first."; \
		exit 1; \
	fi
	$(INSTANCE) fg

start:
	@if [ ! -f "$(SECRETS_LOCAL)" ]; then \
		echo "Missing $(SECRETS_LOCAL). Run 'make secrets' first."; \
		exit 1; \
	fi
	$(INSTANCE) start

stop:
	$(INSTANCE) stop

restart:
	@if [ ! -f "$(SECRETS_LOCAL)" ]; then \
		echo "Missing $(SECRETS_LOCAL). Run 'make secrets' first."; \
		exit 1; \
	fi
	$(INSTANCE) restart

status:
	$(INSTANCE) status

test:
	@if [ ! -f "$(SECRETS_LOCAL)" ]; then \
		echo "Missing $(SECRETS_LOCAL). Run 'make secrets' first."; \
		exit 1; \
	fi
	$(TEST_RUNNER)

build-js:
	$(MAKE) -C src/imio.omnia.tinymce build-js
	$(MAKE) -C src/imio.omnia.assistant build-js

clean-js:
	$(MAKE) -C src/imio.omnia.tinymce clean-js
	$(MAKE) -C src/imio.omnia.assistant clean-js

clean-all:
	rm -rf bin include lib develop-eggs eggs parts var
	rm -f pyvenv.cfg .installed.cfg .mr.developer.cfg
