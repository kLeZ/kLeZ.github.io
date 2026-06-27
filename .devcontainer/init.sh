#!/usr/bin/env bash
# Entrypoint idempotente del dev container klez.me.
#
# Viene eseguito automaticamente ad ogni avvio del container (Docker monta
# i volumi PRIMA dell'ENTRYPOINT, quindi il workspace è disponibile qui).
# Controlla se il setup è già stato fatto e salta i passi già completati,
# rendendo i riavvii successivi istantanei.
#
# Pattern Gitpod equivalente:
#   init    → submodule + bundle install (primo avvio, lento)
#   command → exec "$@"                 (ad ogni avvio, istantaneo)
#
# Modalità:
#   CMD = bash              → shell interattiva (make shell, make serve)
#   CMD = /usr/sbin/sshd -D → daemon SSH (make up, per VSCodium open-remote-ssh)
set -e

WS="${WORKSPACE:-/workspace}"
cd "$WS"

# Inizializza submodule solo se non già presenti
# (premonition e SgEExt sono plugin Jekyll caricati come submodule git)
if [ -f .gitmodules ] && [ ! -d _plugins/premonition/.git ]; then
    echo "[klez-init] Inizializzazione submodule..."
    git submodule update --init --recursive
fi

# Installa gem solo se vendor/bundle non esiste ancora
# (vendor/bundle persiste nel workspace montato: il costo è solo al primo avvio)
if [ ! -d vendor/bundle ]; then
    echo "[klez-init] Prima installazione gem — qualche minuto..."
    bundle config set --local path vendor/bundle
    bundle install
fi

# Modalità daemon SSH: prepara authorized_keys dal mount della directory .ssh dell'host.
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

exec "$@"
