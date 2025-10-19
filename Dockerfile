FROM postgres:17

WORKDIR /app

# Install dependencies: pgcopydb, lz4, SSH (client+server), curl, gnupg, flyctl
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        gnupg \
        lz4 \
        jq \
        openssh-client \
        openssh-server \
        awscli \
        parallel \
        micro \
        pgcopydb && \
    curl -L https://fly.io/install.sh | sh && \
    ln -s /root/.fly/bin/flyctl /usr/local/bin/fly && \
    rm -rf /var/lib/apt/lists/*

# SSH setup
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Copy the private key into the image (internal use only)
# Optional: also COPY fly_migration.pub if you want it inside the container
COPY fly_migration /root/.ssh/fly_migration

# Correct key permissions
RUN chown root:root /root/.ssh/fly_migration && chmod 600 /root/.ssh/fly_migration

# Write SSH config with your host
RUN printf '%s\n' \
  'Host fly-migration' \
  '     HostName 149.248.204.90' \
  '     Port 2222' \
  '     User root' \
  '     IdentityFile ~/.ssh/fly_migration' \
  '     StrictHostKeyChecking no' \
  '     UserKnownHostsFile /dev/null' \
  > /root/.ssh/config && chmod 600 /root/.ssh/config

COPY . .

ENTRYPOINT ["/bin/sh"]
