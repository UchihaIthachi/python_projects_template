ifeq ($(GITHUB_ACTIONS),true)
  ifeq ($(OS),Windows_NT)
	SHELL := cmd.exe
  else
	SHELL := /bin/sh
  endif
endif

.ONESHELL:
ENV_PREFIX=$(shell python -c "import sys; from pathlib import Path; print('.venv/bin/' if Path('.venv/bin/pip').exists() else '')")
USING_POETRY=$(shell grep "tool.poetry" pyproject.toml && echo "yes")

.PHONY: help
help:             ## Show the help.
	@echo "Usage: make <target>"
	@echo ""
	@echo "Targets:"
	@fgrep "##" Makefile | fgrep -v fgrep

.PHONY: show
show:             ## Show the current environment.
	@echo "Current environment:"
	@if [ "$(USING_POETRY)" ]; then poetry env info && exit; fi
	@echo "Running using $(ENV_PREFIX)"
	@$(ENV_PREFIX)python -V
	@$(ENV_PREFIX)python -m site

.PHONY: install
install: .venv      ## Install the project in dev mode.
	@echo "Don't forget to run 'make virtualenv' if you got errors."
	$(ENV_PREFIX)pip install -e .[dev]

.PHONY: fmt
fmt:              ## Format code using black & isort.
	$(ENV_PREFIX)isort src/
	$(ENV_PREFIX)black -l 79 src/
	$(ENV_PREFIX)black -l 79 tests/

.PHONY: lint
lint:             ## Run pep8, black, mypy linters.
	$(ENV_PREFIX)flake8 src/
	$(ENV_PREFIX)black -l 79 --check src/
	$(ENV_PREFIX)black -l 79 --check tests/
	$(ENV_PREFIX)mypy --ignore-missing-imports src/

.PHONY: test
test: lint install-test-deps  ## Run tests and generate coverage report
	@echo "Running tests..."
	@if ! $(ENV_PREFIX)python -m pytest --collect-only > /dev/null 2>&1; then \
		echo "No tests found, skipping pytest."; \
	else \
		$(ENV_PREFIX)python -m pytest -v --cov=src -q --no-summary tests/; \
		$(ENV_PREFIX)python -m coverage xml; \
		$(ENV_PREFIX)python -m coverage html; \
	fi

.PHONY: test-win

test-win:
	@python -m pytest -s -vvvv -l --tb=long tests || echo 'No tests to run'

.PHONY: install-test-deps
install-test-deps: requirements-test.txt
	$(ENV_PREFIX)pip install -r requirements-test.txt

.PHONY: watch
watch:            ## Run tests on every change.
	ls **/**.py | entr $(ENV_PREFIX)pytest -s -vvv -l --tb=long --maxfail=1 tests/

.PHONY: clean
clean:              ## Clean unused files.
	@find ./ -name '*.pyc' -exec rm -f {} \;
	@find ./ -name '__pycache__' -exec rm -rf {} \;
	@find ./ -name 'Thumbs.db' -exec rm -f {} \;
	@find ./ -name '*~' -exec rm -f {} \;
	@rm -rf .cache
	@rm -rf .pytest_cache
	@rm -rf .mypy_cache
	@rm -rf build
	@rm -rf dist
	@rm -rf *.egg-info
	@rm -rf htmlcov
	@rm -rf .tox/
	@rm -rf docs/_build

.PHONY: virtualenv
virtualenv: .venv   ## Create a virtual environment.
.venv:
	@echo "creating virtualenv ..."
	@python3 -m venv .venv
	@$(ENV_PREFIX)pip install -U pip
	@$(ENV_PREFIX)pip install -r requirements.txt
	@echo
	@echo "!!! Please run 'source .venv/bin/activate' to enable the environment !!!"

.PHONY: release
release:          ## Create a new tag for release.
	@echo "WARNING: This operation will create a version tag and push to github"
	@read -p "Version? (provide the next x.y.z semver) : " TAG
	@echo "$${TAG}" > src/VERSION
	@$(ENV_PREFIX)gitchangelog > HISTORY.md
	@git add src/VERSION HISTORY.md
	@git commit -m "release: version $${TAG} 🚀"
	@echo "creating git tag : $${TAG}"
	@git tag $${TAG}
	@git push -u origin HEAD --tags
	@echo "Github Actions will detect the new tag and release the new version."

.PHONY: docs
docs:             ## Build the documentation.
	@echo "building documentation ..."
	@$(ENV_PREFIX)mkdocs build
	URL="site/index.html"; xdg-open $$URL || sensible-browser $$URL || x-www-browser $$URL || gnome-open $$URL || open $$URL

.PHONY: switch-to-poetry
switch-to-poetry:   ## Switch to poetry package manager.
	@echo "Switching to poetry ..."
	@poetry install --no-interaction
	@echo "You have switched to https://python-poetry.org/ package manager."
	@echo "Please run 'poetry shell' or 'poetry run src'"

.PHONY: init
init:             ## Initialize the project based on an application template.
	@./.github/init.sh


# This project has been generated from rochacbruno/python-project-template
# __author__ = 'rochacbruno'
# __repo__ = https://github.com/rochacbruno/python-project-template
# __sponsor__ = https://github.com/sponsors/rochacbruno/
