FROM docker.io/library/caddy:2.11.7-builder@sha256:c2fc374fd352439d76e1777b28d97d9f6d9c1dd86116db9227460374d46097d5 AS builder

# Remove these overrides when Caddy includes the patched dependency versions.
RUN xcaddy build \
    --with github.com/caddy-dns/porkbun@v0.3.1 \
    --replace golang.org/x/net=golang.org/x/net@v0.60.0 \
    --replace github.com/go-chi/chi/v5=github.com/go-chi/chi/v5@v5.4.0

FROM docker.io/library/caddy:2.11.7@sha256:504a44d7d74bd2bc28a66afc4774912fc21223ca8a67734af1c54ab2f999b489

# The pinned runtime predates Alpine's Brotli security update.
RUN apk upgrade --no-cache brotli-libs

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
