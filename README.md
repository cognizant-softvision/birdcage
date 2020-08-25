# Birdcage

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/cognizant-softvision/birdcage)
![Birdcage CI](https://github.com/cognizant-softvision/birdcage/workflows/Birdcage%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/cognizant-softvision/birdcage/badge.svg?branch=main)](https://coveralls.io/github/cognizant-softvision/birdcage?branch=main)

## Introduction

This is a simple tool providing an API and UI for the manual approval of a canary deployments via
[Flagger](https://flagger.app/).

![screenshot](https://github.com/cognizant-softvision/birdcage/raw/main/biredcage-screenshot.png)

## Deployment

Generate a new secret key.

```shell
  ❯ mix phx.gen.secret
  NNX4VmYc8t/VQqxYxPhRapFgLqS3f9rHvMLf8H5mo1l6M8leX+IE+mSH1bKBg9qp
```

Run database migrations.

```shell
  ❯ docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=eIkH9y3yomiSMvWSzYbnQOxEkUGdpatcnhxbhKkMHzzw5PDfGEEHk3exLNrLqE3N \
    -e DATABASE_URL=ecto://postgres:postgres@localhost/birdcage \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest \
    eval "Birdcage.Release.migrate"
```

Run without Authentication.

```shell
  ❯ docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=eIkH9y3yomiSMvWSzYbnQOxEkUGdpatcnhxbhKkMHzzw5PDfGEEHk3exLNrLqE3N \
    -e APP_URL=https://birdcage.local:8080 \
    -e DATABASE_URL=ecto://postgres:postgres@localhost/birdcage \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest \
    start
```

Run with [OpenID Connect](https://www.keycloak.org/docs/latest/authorization_services/index.html#_resource_server_create_client) Authentication.

```shell
  ❯ docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=eIkH9y3yomiSMvWSzYbnQOxEkUGdpatcnhxbhKkMHzzw5PDfGEEHk3exLNrLqE3N \
    -e APP_URL=https://birdcage.local:8080 \
    -e OIDC_ENABLED=true \
    -e OIDC_DISCOVERY_DOCUMENT_URI=https://auth.birdcage.local/auth/realms/test/.well-known/openid-configuration \
    -e OIDC_CLIENT_ID=birdcage \
    -e OIDC_CLIENT_SECRET=+o7y6mn2IMCvazRv2Xxv6erd1ImYL9hg \
    -e OIDC_CLIENT_ROLE=user \
    -e OIDC_REDIRECT_URI=https://birdcage.local:8080/session/callback \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest \
    start
```

Run with Slack bot enabled.

```shell
  ❯ docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=eIkH9y3yomiSMvWSzYbnQOxEkUGdpatcnhxbhKkMHzzw5PDfGEEHk3exLNrLqE3N \
    -e APP_URL=https://birdcage.local:8080 \
    -e BOT_ENABLED=true \
    -e BOT_SLACK_TOKEN=<Slack Token> \
    -e BOT_NAME=birdcage \
    -e BOT_ALIAS=birdcage \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest \
    start
```

## Configuring Flagger Webhooks

https://docs.flagger.app/usage/webhooks#manual-gating

```yaml
webhooks:
  - name: 'Confirm Rollout'
    type: confirm-rollout
    url: https://birdcage.local:8080/api/confirm/rollout
  - name: 'Confirm Promotion'
    type: confirm-promotion
    url: https://birdcage.local:8080/api/confirm/promotion
  - name: 'Send Events'
    type: event
    url: https://birdcage.local:8080/api/event
```
