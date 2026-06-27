.DEFAULT_GOAL := help
.PHONY: build shell serve draft publish emojis up down logs help

COMPOSE = docker compose

## — Immagine ——————————————————————————————————————————————

build: ## Build dell'immagine dev (prima volta e dopo modifiche al Dockerfile)
	$(COMPOSE) build

## — Modalità interattiva (terminale) —————————————————————

shell: ## Shell interattiva nel container (vim, emacs, nano, ecc.)
	$(COMPOSE) run --rm dev bash

serve: ## Jekyll serve con livereload → http://localhost:4000
	$(COMPOSE) run --rm --service-ports dev bash _scripts/serve

## — Modalità daemon SSH (VSCodium open-remote-ssh) ———————

up: ## Avvia il container come daemon SSH su porta 2222
	$(COMPOSE) up -d daemon

down: ## Ferma e rimuove il container daemon
	$(COMPOSE) down

logs: ## Mostra log del container daemon
	$(COMPOSE) logs -f daemon

## — Contenuto ————————————————————————————————————————————

draft: ## Crea un nuovo draft:  make draft TITLE="Il mio titolo"
	$(COMPOSE) run --rm dev bash _scripts/draft "$(TITLE)"

publish: ## Promuove i draft in _posts/ con data corrente
	$(COMPOSE) run --rm dev bash _scripts/publish

emojis: ## Rigenera le emoji da _posts/ (richiede Python 3 + SgEExt)
	$(COMPOSE) run --rm dev bash _scripts/emojis

## — Aiuto ————————————————————————————————————————————————

help: ## Mostra questo messaggio
	@echo "Uso: make <target>"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
