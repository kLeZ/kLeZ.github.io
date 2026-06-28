#!/usr/bin/env bash
# Entrypoint idempotente del dev container klez.me.
#
# Viene eseguito automaticamente ad ogni avvio del container (Docker monta
# i volumi PRIMA dell'ENTRYPOINT, quindi il workspace è disponibile qui).
# Controlla se il setup è già stato fatto e salta i passi già completati,
# rendendo i riavvii successivi istantanei.
#
# Gira come root (necessario per riconciliare uid/gid e per sshd), poi
# SCENDE a 'dev' via gosu per setup e comando: così ogni file prodotto
# (vendor/, _site/, draft, ...) appartiene all'utente host su OGNI percorso
# (make/compose, VS Code, VSCodium/DDorch, Emacs/TRAMP) — un solo punto di fix.
#
# Modalità:
#   CMD = bash              → shell interattiva (make shell, make serve)
#   CMD = /usr/sbin/sshd -D → daemon SSH (make up, per VSCodium open-remote-ssh)
set -e

WS="${WORKSPACE:-/workspace}"
cd "$WS"

# --- Riconciliazione UID/GID host → utente 'dev' ----------------------------
# HOST_UID/HOST_GID arrivano da docker-compose / devcontainer.json (default 1000
# se vuoti/assenti). Allineare qui evita file root-owned e rende la cosa portabile
# tra macchine/utenti con uid diverso senza ricostruire l'immagine.
HOST_UID="${HOST_UID:-1000}"; [ -z "$HOST_UID" ] && HOST_UID=1000
HOST_GID="${HOST_GID:-1000}"; [ -z "$HOST_GID" ] && HOST_GID=1000

if [ "$(id -g dev)" != "$HOST_GID" ]; then
    groupmod -g "$HOST_GID" dev 2>/dev/null || groupmod -o -g "$HOST_GID" dev
fi
if [ "$(id -u dev)" != "$HOST_UID" ]; then
    usermod -u "$HOST_UID" dev 2>/dev/null || usermod -o -u "$HOST_UID" dev
fi
chown -R "$HOST_UID:$HOST_GID" /home/dev 2>/dev/null || true

# Esegue un comando come 'dev' con HOME corretta. gosu fa exec (nessun processo
# extra, segnali/TTY puliti) ma NON imposta HOME: senza, bundler/git scrivono in
# /root e falliscono — quindi la passiamo esplicitamente.
as_dev() { gosu dev env HOME=/home/dev "$@"; }

# --- Setup workspace (come dev) ---------------------------------------------
# Inizializza submodule solo se non già presenti
# (premonition e SgEExt sono plugin Jekyll caricati come submodule git)
if [ -f .gitmodules ] && [ ! -e _plugins/premonition/.git ]; then
    echo "[klez-init] Inizializzazione submodule..."
    as_dev git submodule update --init --recursive
fi

# Installa gem solo se vendor/bundle non esiste ancora
# (vendor/bundle persiste nel workspace montato: il costo è solo al primo avvio)
if [ ! -d vendor/bundle ]; then
    echo "[klez-init] Prima installazione gem — qualche minuto..."
    as_dev bundle config set --local path vendor/bundle
    as_dev bundle install
fi

# --- Modalità daemon SSH: authorized_keys dal mount .ssh dell'host ----------
# Il servizio 'daemon' in docker-compose.yml monta ~/.ssh → /home/dev/.ssh-host:ro
if [ "${1}" = "/usr/sbin/sshd" ]; then
    AK="/home/dev/.ssh/authorized_keys"
    mkdir -p /home/dev/.ssh && chmod 700 /home/dev/.ssh
    if [ -d /home/dev/.ssh-host ]; then
        # Raccoglie id_rsa.pub, id_ed25519.pub, id_ecdsa.pub, ecc.
        cat /home/dev/.ssh-host/id_*.pub > "$AK" 2>/dev/null || true
        # Aggiunge anche authorized_keys dell'host se presente
        [ -f /home/dev/.ssh-host/authorized_keys ] && \
            cat /home/dev/.ssh-host/authorized_keys >> "$AK" 2>/dev/null || true
    fi
    [ -f "$AK" ] && chmod 600 "$AK"
    chown -R dev:dev /home/dev/.ssh
fi

# --- Auto-serve in background (come dev) ------------------------------------
# Attivo solo con AUTO_SERVE=1 (daemon/devcontainer): all'avvio del container il
# server è già su http://localhost:4000. Mai per i one-shot (make shell/draft/
# publish) né quando il comando stesso è già un serve (evita doppio bind su 4000).
if [ "${AUTO_SERVE:-0}" = "1" ] && [[ "$*" != *serve* ]]; then
    echo "[klez-init] Auto-serve → http://localhost:4000 (output nei log del container: make logs)"
    # NIENTE redirect su file dentro $WS: un log nell'albero sorgente innesca un loop
    # infinito di rebuild del watcher Jekyll (listen) — jekyll scrive il log, il watcher
    # vede la modifica, rigenera, riscrive il log, ... L'output va sullo stdout del
    # container, visibile con 'make logs' / 'docker compose logs daemon'.
    as_dev bash -c "cd '$WS' && exec bundle exec jekyll serve --livereload --drafts --host 0.0.0.0" &
fi

# --- Exec del comando -------------------------------------------------------
if [ "${1}" = "/usr/sbin/sshd" ]; then
    exec "$@"                                  # sshd richiede root; le sessioni SSH entrano come dev
else
    exec gosu dev env HOME=/home/dev "$@"      # comando interattivo come dev (= host)
fi
