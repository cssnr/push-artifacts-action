[![Release](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/release.yaml?logo=github&logoColor=white&label=release)](https://github.com/cssnr/push-artifacts-action/actions/workflows/release.yaml)
[![Test](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/test.yaml?logo=github&logoColor=white&label=test)](https://github.com/cssnr/push-artifacts-action/actions/workflows/test.yaml)
[![Lint](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/lint.yaml?logo=github&logoColor=white&label=lint)](https://github.com/cssnr/push-artifacts-action/actions/workflows/lint.yaml)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/push-artifacts-action?logo=github)](https://github.com/cssnr/push-artifacts-action/releases/latest)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/cssnr/push-artifacts-action?logo=github&logoColor=white&label=updated)](https://github.com/cssnr/push-artifacts-action/graphs/commit-activity)
[![Codeberg Last Commit](https://img.shields.io/gitea/last-commit/cssnr/push-artifacts-action/master?gitea_url=https%3A%2F%2Fcodeberg.org%2F&logo=codeberg&logoColor=white&label=updated)](https://codeberg.org/cssnr/push-artifacts-action)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/push-artifacts-action?logo=htmx&logoColor=white)](https://github.com/cssnr/push-artifacts-action)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&logoColor=white)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)

# Push Artifacts Action

- [Inputs](#Inputs)
- [Examples](#Examples)
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

| input   | required | default   | description              |
| ------- | :------: | --------- | ------------------------ |
| source  | **Yes**  | -         | Source Directory         |
| dest    |    -     | `/static` | Destination Directory \* |
| host    | **Yes**  | -         | RSYNC Host               |
| user    | **Yes**  | -         | RSYNC User               |
| pass    | **Yes**  | -         | RSYNC Pass               |
| port    |    -     | `22`      | RSYNC Port               |
| webhost |    -     | -         | HTTP Web Host for URL \* |
| webhook |    -     | -         | Discord Webhook \*       |
| comment |    -     | `true`    | Add a Comment to PRs     |
| token   |    -     | -         | For use with a PAT       |

**dest** - Remote destination directory that should be the root of your web server directory.
The full remote path will be {dest}/{owner}/{repo}/{run#}

**webhost** - Web host where the `dest` is available at. The full URL will be {webhost}/{owner}/{repo}/{run#}

**webhook** - A Discord Webhook URL that if provided will be posted to.

For full details see: [src/main.sh](src/main.sh)

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

# Support

For general help or to request a feature, see:

- Q&A Discussion: https://github.com/cssnr/push-artifacts-action/discussions/categories/q-a
- Request a Feature: https://github.com/cssnr/push-artifacts-action/discussions/categories/feature-requests

If you are experiencing an issue/bug or getting unexpected results, you can:

- Report an Issue: https://github.com/cssnr/push-artifacts-action/issues
- Chat with us on Discord: https://discord.gg/wXy6m2X8wY
- Provide General
  Feedback: [https://cssnr.github.io/feedback/](https://cssnr.github.io/feedback/?app=Push%20Artifacts)

# Contributing

Currently, the best way to contribute to this project is to star this project on GitHub.

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

For a full list of current projects to support visit: [https://cssnr.github.io/](https://cssnr.github.io/)
