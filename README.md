# Birdcage

![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/cognizant-softvision/birdcage)
![Birdcage CI](https://github.com/cognizant-softvision/birdcage/workflows/Birdcage%20CI/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/cognizant-softvision/birdcage/badge.svg?branch=main)](https://coveralls.io/github/cognizant-softvision/birdcage?branch=main)

## Introduction

This is a simple tool providing an API and UI for the manual approval of a canary deployments via
[Flagger](https://flagger.app/).

![screenshot](https://github.com/cognizant-softvision/birdcage/raw/main/biredcage-screenshot.png)

## Deployment

Run without Slack bot enabled.

```shell
  docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=<32-64 characters long> \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest
```

Run with Slack bot enabled.

```shell
  docker run -p 8080:4000 \
    -e PORT=4000 \
    -e SECRET_KEY_BASE=<32-64 characters long> \
    -e BOT_ENABLED=true \
    -e BOT_SLACK_TOKEN=<Slack Token> \
    -e BOT_NAME=birdcage \
    -e BOT_ALIAS=birdcage \
    -e BOT_APP_URL=https://birdcage.local:8080 \
    docker.pkg.github.com/cognizant-softvision/birdcage/birdcage:latest
```

## Configuring Flagger Webhooks

https://docs.flagger.app/usage/webhooks#manual-gating

```yaml
webhooks:
  - name: "Confirm Rollout"
    type: confirm-rollout
    url: https://birdcage.local:8080/api/confirm/rollout
  - name: "Confirm Promotion"
    type: confirm-promotion
    url: https://birdcage.local:8080/api/confirm/promotion
```
