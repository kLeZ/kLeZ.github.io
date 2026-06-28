.DEFAULT_GOAL := help
.PHONY: build shell serve draft publish emojis up down logs help

COMPOSE = docker compose

# Passa uid/gid dell'host al container: i file prodotti (vendor/, _site/, draft, ...)
# restano di proprietà dell'host, non di root. L'entrypoint riconcilia 'dev' a questi.
export HOST_UID := $(shell id -u)
export HOST_GID := $(shell id -g)

# Se il container daemon è in esecuzione (make up / VSCodium / Emacs), instrada i
# comandi DENTRO di esso: un solo container, nessun conflitto sulla porta 4000.
# 'exec' salta l'ENTRYPOINT, quindi forziamo --user dev + HOME esplicita.
DAEMON := $(shell $(COMPOSE) ps -q daemon 2>/dev/null)
ifeq ($(DAEMON),)
  IN       = $(COMPOSE) run --rm dev
  IN_PORTS = $(COMPOSE) run --rm --service-ports dev
else
  IN       = $(COMPOSE) exec --user dev -e HOME=/home/dev daemon
  IN_PORTS = $(COMPOSE) exec --user dev -e HOME=/home/dev daemon
endif

## — Immagine ——————————————————————————————————————————————

build: ## Build dell'immagine dev (prima volta e dopo modifiche al Dockerfile)
	$(COMPOSE) build

## — Modalità interattiva (terminale) —————————————————————

shell: ## Shell interattiva nel container (vim, emacs, nano, ecc.)
	$(IN) bash

serve: ## Jekyll serve con livereload → http://localhost:4000
ifeq ($(DAEMON),)
	$(IN_PORTS) serve
else
	@echo "Daemon attivo: il server è già su http://localhost:4000 (log: make logs)"
endif

## — Modalità daemon SSH (VSCodium open-remote-ssh) ———————

up: ## Avvia il container come daemon SSH su porta 2222 (auto-serve su :4000)
	$(COMPOSE) up -d daemon

down: ## Ferma e rimuove il container daemon
	$(COMPOSE) down

logs: ## Mostra log del container daemon (sshd + auto-serve Jekyll)
	$(COMPOSE) logs -f daemon

## — Contenuto ————————————————————————————————————————————

draft: ## Crea un nuovo draft:  make draft TITLE="Il mio titolo"
	$(IN) draft "$(TITLE)"

publish: ## Promuove i draft in _posts/ con data corrente
	$(IN) publish

emojis: ## Rigenera le emoji da _posts/ (richiede Python 3 + SgEExt)
	$(IN) emojis

## — Aiuto ————————————————————————————————————————————————

help: ## Mostra questo messaggio
	@echo "Uso: make <target>"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'
