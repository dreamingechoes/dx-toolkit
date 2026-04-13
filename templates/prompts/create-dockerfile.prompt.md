---
description: 'Create an optimized, secure Dockerfile with multi-stage builds, caching, and production best practices. Use for containerizing any application.'
agent: 'agent'
---

Create a production-ready Dockerfile for the described application.

## Procedure

1. **Detect the tech stack** from the codebase (language, framework, package manager)
2. **Generate a multi-stage Dockerfile** with:
   - Build stage (dependencies + compilation)
   - Production stage (minimal runtime image)
3. **Include** a `.dockerignore` file if one doesn't exist

## Dockerfile Best Practices

- Use specific image tags (not `latest`) — pin major.minor versions
- Multi-stage builds to minimize final image size
- Order layers from least to most frequently changing (COPY lock files before source)
- Use BuildKit cache mounts (`--mount=type=cache`) for package managers
- Run as non-root user in production stage
- Include `HEALTHCHECK` instruction
- Set appropriate `EXPOSE` ports
- Use `COPY --link` when possible for better cache behavior
- Handle signals properly (`ENTRYPOINT` with exec form)
- Set `ENV NODE_ENV=production` or equivalent

## Security Hardening

- Use minimal base images (Alpine, distroless, or slim variants)
- Don't install unnecessary packages
- Remove package manager caches in the same layer
- Never copy secrets into the image — use `--mount=type=secret` for build-time secrets
- Scan with `docker scout` or Trivy

## Output

- `Dockerfile` with inline comments explaining each decision
- `.dockerignore` if needed
- `docker-compose.yml` for local development if useful
- Build and run commands
