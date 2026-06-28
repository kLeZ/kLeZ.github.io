FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    RBENV_ROOT=/usr/local/rbenv \
    PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# Dipendenze di sistema:
#   build-essential + lib*: compilazione Ruby via rbenv
#   nodejs: richiesto da execjs gem
#   python3: richiesto da _scripts/emojis (SgEExt/sgeext.py)
#   openssh-client: per git submodule update su HTTPS/SSH
#   openssh-server: modalità daemon SSH per VSCodium open-remote-ssh
#   sudo: operazioni privilegiate dall'utente dev
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git curl ca-certificates \
    libssl-dev libreadline-dev zlib1g-dev \
    libyaml-dev libffi-dev \
    nodejs \
    python3 python3-pip python3-requests \
    openssh-client \
    openssh-server \
    sudo \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add safe.directory '*'

# rbenv + ruby-build (system-wide, accessibile a tutti gli utenti)
RUN git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT \
    && git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build

# Ruby 3.2.3 — Jekyll 3.9.x non funziona con Ruby 3.3+ (incompatibilità logger API).
# Per migrare: cambia RUBY_VERSION e aggiorna .ruby-version + Gemfile.lock.
ARG RUBY_VERSION=3.2.3
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

# PATH rbenv + locale per tutte le sessioni shell.
# /etc/profile.d/ è letto solo da shell login; le sessioni non-login (SSH senza -l,
# docker exec, VSCodium terminal) richiedono /etc/bash.bashrc e ~/.bashrc.
RUN printf 'export RBENV_ROOT=/usr/local/rbenv\n\
export PATH=/usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH\n\
export LANG=C.UTF-8\n\
export LC_ALL=C.UTF-8\n' > /etc/profile.d/klez-dev.sh \
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
