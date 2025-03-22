[![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/push-artifacts-action?sort=semver&filter=!v*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/push-artifacts-action/tags)
[![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/push-artifacts-action?sort=semver&filter=!v*.*.*&logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/push-artifacts-action/tags)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/push-artifacts-action?logo=git&logoColor=white&labelColor=585858&label=%20)](https://github.com/cssnr/push-artifacts-action/releases/latest)
[![Workflow Release](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/release.yaml?logo=github&label=release)](https://github.com/cssnr/push-artifacts-action/actions/workflows/release.yaml)
[![Workflow Test](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/test.yaml?logo=github&label=test)](https://github.com/cssnr/push-artifacts-action/actions/workflows/test.yaml)
[![Workflow Lint](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/lint.yaml?logo=github&label=lint)](https://github.com/cssnr/push-artifacts-action/actions/workflows/lint.yaml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/push-artifacts-action?logo=github&label=updated)](https://github.com/cssnr/push-artifacts-action/graphs/commit-activity)
[![Codeberg Last Commit](https://img.shields.io/gitea/last-commit/cssnr/push-artifacts-action/master?gitea_url=https%3A%2F%2Fcodeberg.org%2F&logo=codeberg&logoColor=white&label=updated)](https://codeberg.org/cssnr/push-artifacts-action)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/push-artifacts-action?logo=sharp&logoColor=white)](https://github.com/cssnr/push-artifacts-action)
[![GitHub repo size](https://img.shields.io/github/repo-size/cssnr/push-artifacts-action?logo=bookstack&logoColor=white&label=size)](https://github.com/cssnr/push-artifacts-action)
[![GitHub Discussions](https://img.shields.io/github/discussions/cssnr/push-artifacts-action)](https://github.com/cssnr/push-artifacts-action/discussions)
[![GitHub Forks](https://img.shields.io/github/forks/cssnr/push-artifacts-action?style=flat&logo=github)](https://github.com/cssnr/push-artifacts-action/forks)
[![GitHub Repo Stars](https://img.shields.io/github/stars/cssnr/push-artifacts-action?style=flat&logo=github)](https://github.com/cssnr/push-artifacts-action/stargazers)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&label=org%20stars)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)

# Push Artifacts Action

- [Inputs](#Inputs)
  - [Permissions](#Permissions)
- [Examples](#Examples)
- [Tags](#Tags)
- [Support](#Support)
- [Contributing](#Contributing)

This is really just a POC, but works and is in use. While it does rsync artifacts to a remote host, it is designed for
screenshots because it creates a [swiper.js](https://github.com/nolimits4web/swiper) index.html with all the files
synced and if served from a web server can be viewed in the browser.

Will rsync the `source` (directory in the build) to `host`@`user` with `pass` on `port` to `dest` remote directory and
append the `GITHUB_REPOSITORY` (org/repo) followed by `GITHUB_RUN_NUMBER` then `GITHUB_RUN_ATTEMPT` and optionally send
a notification to a Discord `webhook` or comment on the PR prepending the `webhost` to the path.

> [!WARNING]  
> This action and this GitHub repository will soon be renamed before `v1.0.0` is published.

## Inputs

| Input   |  Req.   | Default   | Input&nbsp;Description   |
| :------ | :-----: | :-------- | :----------------------- |
| source  | **Yes** | -         | Source Directory         |
| dest    |    -    | `/static` | Destination Directory \* |
| host    | **Yes** | -         | RSYNC Host               |
| user    | **Yes** | -         | RSYNC User               |
| pass    | **Yes** | -         | RSYNC Pass               |
| port    |    -    | `22`      | RSYNC Port               |
| webhost |    -    | -         | HTTP Web Host for URL \* |
| webhook |    -    | -         | Discord Webhook \*       |
| comment |    -    | `true`    | Add a Comment to PRs     |
| token   |    -    | -         | For use with a PAT       |

For more details see [action.yml](action.yml) and [src/main.sh](src/main.sh).

**dest** - Remote destination directory that should be the root of your web server directory.
The full remote path will be {dest}/{owner}/{repo}/{run#}

**webhost** - Web host where the `dest` is available at. The full URL will be {webhost}/{owner}/{repo}/{run#}

**webhook** - A Discord Webhook URL that if provided will be posted to.

```yaml
- name: 'Push Artifacts'
  uses: cssnr/push-artifacts-action@master
  with:
    source: 'tests/screenshots'
    dest: '/static'
    host: ${{ secrets.RSYNC_HOST }}
    user: ${{ secrets.RSYNC_USER }}
    pass: ${{ secrets.RSYNC_PASS }}
    port: ${{ secrets.RSYNC_PORT }}
    webhost: 'https://example.com'
    webhook: ${{ secrets.DISCORD_WEBHOOK }}
    token: ${{ secrets.GITHUB_TOKEN }}
```

### Permissions

This action requires the following permissions to add pull request comments:

```yaml
permissions:
  pull-requests: write
```

Permissions documentation for [Workflows](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/controlling-permissions-for-github_token) and [Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication).

## Outputs

| Output | Output&nbsp;Description |
| :----- | :---------------------- |
| url    | Full Screen Shots URL   |

You must provide the `webhost` input for this to function properly.

## Examples

```yaml
name: 'Push Artifacts Test'

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  test:
    name: 'Test'
    runs-on: ubuntu-latest
    timeout-minutes: 5
    permissions:
      pull-requests: write

    steps:
      - name: 'Checkout'
        uses: actions/checkout@v4

      - name: 'Push Artifacts'
        uses: cssnr/push-artifacts-action@master
        with:
          source: 'tests/screenshots'
          dest: '/static'
          host: ${{ secrets.RSYNC_HOST }}
          user: ${{ secrets.RSYNC_USER }}
          pass: ${{ secrets.RSYNC_PASS }}
          port: ${{ secrets.RSYNC_PORT }}
          webhost: 'https://example.com'
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          token: ${{ secrets.GITHUB_TOKEN }}
```

To see this used in actual workflows, check out these examples:  
https://github.com/django-files/django-files/blob/master/.github/workflows/test.yaml  
https://github.com/cssnr/link-extractor/blob/master/.github/workflows/test.yaml

For more examples, you can check out other projects using this action:  
https://github.com/cssnr/push-artifacts-action/network/dependents

## Tags

The following rolling [tags](https://github.com/cssnr/push-artifacts-action/tags) are maintained.

| Version&nbsp;Tag                                                                                                                                                                                                           | Rolling | Bugs | Feat. |   Name    |  Target  | Example  |
| :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: | :--: | :---: | :-------: | :------: | :------- |
| [![GitHub Tag Major](https://img.shields.io/github/v/tag/cssnr/push-artifacts-action?sort=semver&filter=!v*.*&style=for-the-badge&label=%20&color=44cc10)](https://github.com/cssnr/push-artifacts-action/releases/latest) |   ✅    |  ✅  |  ✅   | **Major** | `vN.x.x` | `vN`     |
| [![GitHub Tag Minor](https://img.shields.io/github/v/tag/cssnr/push-artifacts-action?sort=semver&filter=!v*.*.*&style=for-the-badge&label=%20&color=blue)](https://github.com/cssnr/push-artifacts-action/releases/latest) |   ✅    |  ✅  |  ❌   | **Minor** | `vN.N.x` | `vN.N`   |
| [![GitHub Release](https://img.shields.io/github/v/release/cssnr/push-artifacts-action?style=for-the-badge&label=%20&color=red)](https://github.com/cssnr/push-artifacts-action/releases/latest)                           |   ❌    |  ❌  |  ❌   | **Micro** | `vN.N.N` | `vN.N.N` |

You can view the release notes for each version on the [releases](https://github.com/cssnr/push-artifacts-action/releases) page.

The **Major** tag is recommended. It is the most up-to-date and always backwards compatible.
Breaking changes would result in a **Major** version bump. At a minimum you should use a **Minor** tag.

# Support

For general help or to request a feature, see:

- Q&A Discussion: https://github.com/cssnr/push-artifacts-action/discussions/categories/q-a
- Request a Feature: https://github.com/cssnr/push-artifacts-action/discussions/categories/feature-requests

If you are experiencing an issue/bug or getting unexpected results, you can:

- Report an Issue: https://github.com/cssnr/push-artifacts-action/issues
- Chat with us on Discord: https://discord.gg/wXy6m2X8wY
- Provide General Feedback: [https://cssnr.github.io/feedback/](https://cssnr.github.io/feedback/?app=Push%20Artifacts)

For more information, see the CSSNR [SUPPORT.md](https://github.com/cssnr/.github/blob/master/.github/SUPPORT.md#support).

# Contributing

Currently, the best way to contribute to this project is to star this project on GitHub.

For more information, see the CSSNR [CONTRIBUTING.md](https://github.com/cssnr/.github/blob/master/.github/CONTRIBUTING.md#contributing).

Additionally, you can support other GitHub Actions I have published:

- [Stack Deploy Action](https://github.com/cssnr/stack-deploy-action?tab=readme-ov-file#readme)
- [Portainer Stack Deploy](https://github.com/cssnr/portainer-stack-deploy-action?tab=readme-ov-file#readme)
- [VirusTotal Action](https://github.com/cssnr/virustotal-action?tab=readme-ov-file#readme)
- [Mirror Repository Action](https://github.com/cssnr/mirror-repository-action?tab=readme-ov-file#readme)
- [Update Version Tags Action](https://github.com/cssnr/update-version-tags-action?tab=readme-ov-file#readme)
- [Update JSON Value Action](https://github.com/cssnr/update-json-value-action?tab=readme-ov-file#readme)
- [Parse Issue Form Action](https://github.com/cssnr/parse-issue-form-action?tab=readme-ov-file#readme)
- [Cloudflare Purge Cache Action](https://github.com/cssnr/cloudflare-purge-cache-action?tab=readme-ov-file#readme)
- [Mozilla Addon Update Action](https://github.com/cssnr/mozilla-addon-update-action?tab=readme-ov-file#readme)
- [Docker Tags Action](https://github.com/cssnr/docker-tags-action?tab=readme-ov-file#readme)
- [Package Changelog Action](https://github.com/cssnr/package-changelog-action?tab=readme-ov-file#readme)
- [NPM Outdated Check Action](https://github.com/cssnr/npm-outdated-action?tab=readme-ov-file#readme)

For a full list of current projects to support visit: [https://cssnr.github.io/](https://cssnr.github.io/)
