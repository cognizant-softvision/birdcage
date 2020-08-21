# [1.9.0](https://github.com/cognizant-softvision/birdcage/compare/v1.8.1...v1.9.0) (2020-08-21)


### Features

* add support for Events (#10) ([b843c0d](https://github.com/cognizant-softvision/birdcage/commit/b843c0d4515a30a37e34019284647daa43705581)), closes [#10](https://github.com/cognizant-softvision/birdcage/issues/10)

## [1.8.1](https://github.com/cognizant-softvision/birdcage/compare/v1.8.0...v1.8.1) (2020-08-13)


### Bug Fixes

* refactor the flagger slack message handler ([dd6b797](https://github.com/cognizant-softvision/birdcage/commit/dd6b797b7503107e21de555fb42a75224854d3e9))

# [1.8.0](https://github.com/cognizant-softvision/birdcage/compare/v1.7.3...v1.8.0) (2020-08-13)


### Bug Fixes

* failing tests ([3dfafdb](https://github.com/cognizant-softvision/birdcage/commit/3dfafdbf802de6ddf6220e4f7dcf5746a9575396))


### Features

* handle and log events to see what might be useful to display (#9) ([ce343b7](https://github.com/cognizant-softvision/birdcage/commit/ce343b74f42380365865c2207ac8f6ba4e4d05ef)), closes [#9](https://github.com/cognizant-softvision/birdcage/issues/9)

## [1.7.3](https://github.com/cognizant-softvision/birdcage/compare/v1.7.2...v1.7.3) (2020-08-12)


### Bug Fixes

* compile time vs runtime issues with env vars ([a17474a](https://github.com/cognizant-softvision/birdcage/commit/a17474af164c42618db308e7c093e48cf5cd914b))

## [1.7.2](https://github.com/cognizant-softvision/birdcage/compare/v1.7.1...v1.7.2) (2020-08-12)


### Bug Fixes

* cleaned up authentication and added required login plug ([74ffcd6](https://github.com/cognizant-softvision/birdcage/commit/74ffcd61937588d38e0fb542294ef0e59e583a92))

## [1.7.1](https://github.com/cognizant-softvision/birdcage/compare/v1.7.0...v1.7.1) (2020-08-12)


### Bug Fixes

* don't require APP_URL env var ([30f4f83](https://github.com/cognizant-softvision/birdcage/commit/30f4f8323c7814577143328b4e430c7157a9f020))

# [1.7.0](https://github.com/cognizant-softvision/birdcage/compare/v1.6.0...v1.7.0) (2020-08-11)


### Features

* add support for OpenID Connect authentication (#8) ([350d82f](https://github.com/cognizant-softvision/birdcage/commit/350d82f12be48596572df3a59490d00172478519)), closes [#8](https://github.com/cognizant-softvision/birdcage/issues/8)

# [1.6.0](https://github.com/cognizant-softvision/birdcage/compare/v1.5.0...v1.6.0) (2020-08-07)


### Features

* add optional slack bot (#7) ([f7656b9](https://github.com/cognizant-softvision/birdcage/commit/f7656b9615fac5cb540dd27668017bd1ac7b137b)), closes [#7](https://github.com/cognizant-softvision/birdcage/issues/7)

# [1.5.0](https://github.com/cognizant-softvision/birdcage/compare/v1.4.2...v1.5.0) (2020-08-06)


### Chores

* add screenshot to readme ([ddcc285](https://github.com/cognizant-softvision/birdcage/commit/ddcc285f222466b1046c1b83a44df1cbe11a46b5))


### Features

* add simple health check ([89e1da1](https://github.com/cognizant-softvision/birdcage/commit/89e1da13d7db7d63d3eb7fb0dd7547b9a4079f61))

## [1.4.2](https://github.com/cognizant-softvision/birdcage/compare/v1.4.1...v1.4.2) (2020-07-23)


### Bug Fixes

* bump version for next release ([ab0e081](https://github.com/cognizant-softvision/birdcage/commit/ab0e0817fe3cf357e6a4cf97fa981553814b9fe3))
* **actions:** use next version output to control publishing image ([6b3bc43](https://github.com/cognizant-softvision/birdcage/commit/6b3bc434894cc5665867f8e3a55d41ce64a365b5))


### Chores

* **release:** 1.4.2 [skip ci] ([28e36ea](https://github.com/cognizant-softvision/birdcage/commit/28e36ea317b8ecd2e857fbe65d6023fe14dc84af))

## [1.4.2](https://github.com/cognizant-softvision/birdcage/compare/v1.4.1...v1.4.2) (2020-07-23)


### Bug Fixes

* **actions:** use next version output to control publishing image ([6b3bc43](https://github.com/cognizant-softvision/birdcage/commit/6b3bc434894cc5665867f8e3a55d41ce64a365b5))

## [1.4.1](https://github.com/cognizant-softvision/birdcage/compare/v1.4.0...v1.4.1) (2020-07-22)


### Bug Fixes

* update logo and remove unused menus ([44e1f77](https://github.com/cognizant-softvision/birdcage/commit/44e1f775c60f89e51874ad5f07bb31985608f0fd))

# [1.4.0](https://github.com/cognizant-softvision/birdcage/compare/v1.3.0...v1.4.0) (2020-07-22)


### Features

* major refactor to use Ecto.Repo with a custom Adapter for the Nebulex.Cache (#5) ([9dc3775](https://github.com/cognizant-softvision/birdcage/commit/9dc3775df888d331736ab10f8f7ea17462470ac1)), closes [#5](https://github.com/cognizant-softvision/birdcage/issues/5)

# [1.3.0](https://github.com/cognizant-softvision/birdcage/compare/v1.2.2...v1.3.0) (2020-07-19)


### Features

* add relative time the last rollout or promotion was attempted (#4) ([99e7268](https://github.com/cognizant-softvision/birdcage/commit/99e7268277b5b2b6c1be60ed60fe5d705d2c5f7b)), closes [#4](https://github.com/cognizant-softvision/birdcage/issues/4)

## [1.2.2](https://github.com/cognizant-softvision/birdcage/compare/v1.2.1...v1.2.2) (2020-07-16)


### Bug Fixes

* update ci job to build and push versioned docker image to registry ([faf0190](https://github.com/cognizant-softvision/birdcage/commit/faf0190fed27ccfaddbee6f7b64d6a2e12ed6a24))

## [1.2.1](https://github.com/cognizant-softvision/birdcage/compare/v1.2.0...v1.2.1) (2020-07-15)


### Bug Fixes

* disable SwaggerUI in prod ([94e78c3](https://github.com/cognizant-softvision/birdcage/commit/94e78c35fee32d171aff72f6642d53a817f66540))


### Chores

* add ci job to build and push docker image to registry ([3de7168](https://github.com/cognizant-softvision/birdcage/commit/3de7168f884cd940c1c01a707789e3ccb1afc49e))
* configure Elixir Releases and build a release container ([6dee2fd](https://github.com/cognizant-softvision/birdcage/commit/6dee2fda385b0d9141fcdcf05762260d2eedce1f))
* rename Dockerfile for dev use ([440a57b](https://github.com/cognizant-softvision/birdcage/commit/440a57b3756f655d5c4ffb986b35a276b2dcade7))

# [1.2.0](https://github.com/cognizant-softvision/birdcage/compare/v1.1.0...v1.2.0) (2020-07-14)


### Chores

* add badges to readme ([d01480b](https://github.com/cognizant-softvision/birdcage/commit/d01480bde993270247ed54f7ebdc2b1ee419a8f3))
* update coverage badge ([6c14778](https://github.com/cognizant-softvision/birdcage/commit/6c14778ae38a5735941ef062fe3d01f7a87efb6d))


### Features

* added UI to support manual approval of rollouts and promotions (#2) ([1b32510](https://github.com/cognizant-softvision/birdcage/commit/1b32510adc7873a1769974fe425aa76738e2ae91)), closes [#2](https://github.com/cognizant-softvision/birdcage/issues/2)

# [1.1.0](https://github.com/cognizant-softvision/birdcage/compare/v1.0.0...v1.1.0) (2020-07-10)


### Chores

* not using postgres ([9195be7](https://github.com/cognizant-softvision/birdcage/commit/9195be7046fd620781ec952944c01b7b5907230d))


### Features

* implement the confirm rollout webhook (#1) ([a9b0612](https://github.com/cognizant-softvision/birdcage/commit/a9b0612af841ed00ee8c8c84aaabfafc71d30394)), closes [#1](https://github.com/cognizant-softvision/birdcage/issues/1)

# 1.0.0 (2020-07-10)


### Chores

* add credo and coveralls ([29da4f2](https://github.com/cognizant-softvision/birdcage/commit/29da4f2963ecfec41de15437f46e874c7fd5fe99))
* add Github Actions for CI ([d7511b1](https://github.com/cognizant-softvision/birdcage/commit/d7511b1bb0eae6a64d94e2505835f1e6f893c82d))
* generate phoenix app ([430db65](https://github.com/cognizant-softvision/birdcage/commit/430db65b449b9009f5edb6bd4c55c34f191db646))
* initialize new project from starter template ([14c987a](https://github.com/cognizant-softvision/birdcage/commit/14c987aed4c09f2964225424dca0e404396518b4))
* not using db ([cd93972](https://github.com/cognizant-softvision/birdcage/commit/cd93972561d335c5acce4027c396224645a4e17c))


### Features

* define webhook endpoints via OpenApi ([cf54087](https://github.com/cognizant-softvision/birdcage/commit/cf54087a261a90d28616468fdc968095bc5549f9))
