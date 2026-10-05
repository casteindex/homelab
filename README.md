# Homelab

Configuration and deployment files for my self-hosted homelab.

## Structure

```text
homelab/
├── docker/                 # Docker Compose files, Dockerfiles, and service configuration
├── config/                 # Persistent application configuration
├── data/                   # Persistent application data
├── scripts/                # Maintenance and automation scripts
├── .env                    # Environment variables and secrets (not tracked)
├── .env.example            # Environment variable template
└── README.md
```

## Docker

Each service has its own directory under `docker/`.

For example:

```
docker/
├── caddy/
│   ├── compose.yaml
│   ├── Dockerfile
│   └── Caddyfile
├── jellyfin/
│   └── compose.yaml
├── pingvin-share/
│   └── compose.yaml
└── ...
```

Services that need to communicate with each other use the external Docker network:

```
proxy
```

### Starting a service

```
cd docker/<service>
docker compose up -d
```

### Stopping a service

```
docker compose down
```

### Rebuilding a service

```
docker compose up -d --build
```

## Environment Variables

Sensitive values are stored in `.env` and are **not tracked by Git**.

To create the local environment file for the first time:

```
cp .env.example .env
```

Then edit `.env` and provide the appropriate values.

Example:

```
PUID=1000
PGID=1000

DATA_DIR=/srv/homelab/data
CONFIG_DIR=/srv/homelab/config

CLOUDFLARE_API_TOKEN=
```

## Persistent Data

Persistent configuration and application data are stored outside of the containers:

```
/srv/homelab/config
/srv/homelab/data
```

This allows containers to be recreated or updated without losing their persistent state.

## Backups

The `config/` and `data/` directories are intended to be backed up using Restic.

The `docker/` directory contains primarily declarative configuration and is version-controlled with Git, so it can be recreated from the repository.

Secrets such as `.env` should be handled separately and should not be committed to the repository.

## Recovery

If the server needs to be rebuilt from scratch:

1. Install Docker and the required dependencies.
2. Clone this repository.
3. Create and configure `.env` from `.env.example`.
4. Restore `config/` and `data/` from the Restic backup.
5. Create any required external Docker networks.
6. Start the required services with Docker Compose.

For example:

```
git clone <repository-url> /srv/homelab
cd /srv/homelab
cp .env.example .env

# Restore config/ and data/ from backup

cd docker/<service>
docker compose up -d
```

## Philosophy

This repository follows a simple separation of responsibilities:

- **Git** stores the declarative configuration needed to rebuild the homelab.
- **Restic** stores persistent application state and data.
- **`.env`** stores local secrets and environment-specific values.
- **Docker Compose** defines how services are deployed and connected.

The goal is to keep the homelab reproducible while keeping persistent data and secrets separate from the deployment configuration.
