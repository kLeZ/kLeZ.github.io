FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    RBENV_ROOT=/usr/local/rbenv \
    PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:/workspace/_scripts:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Dipendenze di sistema:
#   build-essential + lib*: compilazione Ruby via rbenv
#   nodejs: richiesto da execjs gem
#   python3: richiesto da _scripts/emojis (SgEExt/sgeext.py) e da _scripts/translate
#   jq: richiesto da _scripts/translate (adattatore OpenRouter)
#   openssh-client: per git submodule update su HTTPS/SSH
#   openssh-server: modalità daemon SSH per VSCodium open-remote-ssh
#   sudo: operazioni privilegiate dall'utente dev
#   gosu: drop dei privilegi da root a 'dev' nell'ENTRYPOINT (exec pulito, no fork)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git curl ca-certificates \
    libssl-dev libreadline-dev zlib1g-dev \
    libyaml-dev libffi-dev \
    nodejs \
    python3 python3-pip python3-requests python3-yaml \
    jq \
    openssh-client \
    openssh-server \
    sudo \
    gosu \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add safe.directory '*'

# yq di mikefarah (v4), richiesto da _scripts/translate. Non da apt: il pacchetto
# Debian "yq" è un altro programma, in Python, con un'altra sintassi.
ARG YQ_VERSION=v4.53.3
RUN arch=$(dpkg --print-architecture) \
    && case "$arch" in \
         amd64) sum=fa52a4e758c63d38299163fbdd1edfb4c4963247918bf9c1c5d31d84789eded4 ;; \
         arm64) sum=578648e463a11c1b6db6010cbf41eafed6bee79466fcffa1bb446672cf7945ea ;; \
         *) echo "yq: architettura $arch non prevista" >&2; exit 1 ;; \
       esac \
    && curl -fsSLo /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${arch}" \
    && echo "$sum  /usr/local/bin/yq" | sha256sum -c - \
    && chmod +x /usr/local/bin/yq

# rbenv + ruby-build (system-wide, accessibile a tutti gli utenti)
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT \
    && git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build

# Ruby allineato a .ruby-version (Jekyll 4.4 richiede Ruby >= 2.7).
# Per migrare: cambia RUBY_VERSION e aggiorna .ruby-version + Gemfile.lock.
ARG RUBY_VERSION=3.3.6
RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION

# Bundler pinnato alla versione dichiarata in Gemfile.lock (BUNDLED WITH 2.4.10)
RUN gem install bundler:2.4.10 --no-document

# Utente non-root 'dev' (UID 1000, tipico primo utente Linux).
# I file creati nel workspace bind-mount risultano owned dall'utente host con lo stesso UID.
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# SSH: configurazione server + chiavi host generate al build-time (immutabili nel layer)
RUN mkdir -p /var/run/sshd \
    && ssh-keygen -A \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers dev" >> /etc/ssh/sshd_config

# PATH rbenv + locale + umask per tutte le sessioni shell.
# /etc/profile.d/ è letto solo da shell login; le sessioni non-login (SSH senza -l,
# docker exec, VSCodium terminal) richiedono /etc/bash.bashrc e ~/.bashrc.
# umask 022: 'docker exec' (terminali di VS Code, TRAMP /docker:, make shell nel
# daemon) parte con 0000 e i file nuovi uscirebbero scrivibili da tutti.
RUN printf 'export RBENV_ROOT=/usr/local/rbenv\n\
export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:/workspace/_scripts:$PATH\n\
export LANG=C.UTF-8\n\
export LC_ALL=C.UTF-8\n\
umask 022\n' > /etc/profile.d/klez-dev.sh \
    && for f in /etc/bash.bashrc /home/dev/.bashrc /root/.bashrc; do \
         printf '\n. /etc/profile.d/klez-dev.sh\n' >> "$f"; \
       done

# Entrypoint: inizializza workspace al primo avvio, poi exec il CMD
COPY .devcontainer/init.sh /usr/local/bin/klez-init
RUN chmod +x /usr/local/bin/klez-init

EXPOSE 22
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/klez-init"]
CMD ["bash"]
