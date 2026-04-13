---
description: 'Docker and container standards. Use when writing Dockerfiles, docker-compose files, or container configurations. Covers multi-stage builds, security, and optimization.'
applyTo: '**/Dockerfile*, **/docker-compose*.yml, **/docker-compose*.yaml, **/.dockerignore'
---

# Docker Standards

## Dockerfile

- Use multi-stage builds — separate build and runtime stages
- Pin image versions to major.minor (e.g., `node:22-alpine`, not `node:latest`)
- Use Alpine or slim variants for smaller images
- Order instructions from least to most frequently changing
- Combine `RUN` commands to reduce layers
- Use `COPY --link` for better caching (BuildKit)
- Use `--mount=type=cache` for package manager caches
- Use `--mount=type=secret` for build-time secrets (never `ARG` or `ENV`)

## Runtime

- Run as non-root user: `USER nobody` or create a specific user
- Set `HEALTHCHECK` instruction for orchestrator probes
- Use exec form for `ENTRYPOINT`: `["executable", "param"]`
- Set `STOPSIGNAL` to match your application's graceful shutdown signal
- Expose only necessary ports

## Compose

- Use Compose V2 syntax (`services:` at top level, no `version:` field)
- Define `depends_on` with `condition: service_healthy`
- Use named volumes for persistent data
- Use `profiles` to group optional services
- Set `restart: unless-stopped` for production services
- Use `.env` file for environment variables, not inline `environment:`

## Security

- Scan images with `docker scout` or Trivy
- Don't run as root unless absolutely necessary
- Don't store secrets in images — use runtime secrets
- Keep base images updated
- Use `--no-install-recommends` with apt
