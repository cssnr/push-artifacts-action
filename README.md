[![Tags](https://img.shields.io/github/actions/workflow/status/cssnr/push-artifacts-action/tags.yaml?logo=github&logoColor=white&label=tags)](https://github.com/cssnr/push-artifacts-action/actions/workflows/tags.yaml)
[![GitHub Release Version](https://img.shields.io/github/v/release/cssnr/push-artifacts-action?logo=github)](https://github.com/cssnr/push-artifacts-action/releases/latest)
[![GitHub Top Language](https://img.shields.io/github/languages/top/cssnr/push-artifacts-action?logo=htmx&logoColor=white)](https://github.com/cssnr/push-artifacts-action)
[![GitHub Org Stars](https://img.shields.io/github/stars/cssnr?style=flat&logo=github&logoColor=white)](https://cssnr.github.io/)
[![Discord](https://img.shields.io/discord/899171661457293343?logo=discord&logoColor=white&label=discord&color=7289da)](https://discord.gg/wXy6m2X8wY)

# Push Artifacts Action

This is really just a POC! but it does something...

Will rsync the `source` (directory in the build) to `host`@`user` with `pass` on `port` to `dest` remote directory and
append the `GITHUB_REPOSITORY` (org/repo) followed by `GITHUB_RUN_NUMBER` then `GITHUB_RUN_ATTEMPT` and optionally send
a notification to a Discord `webhook` or comment on the PR prepending the `webhost` to the path.

* [Inputs](#Inputs)
* [Examples](#Examples)
* [Support](#Support)
* [Contributing](#Contributing)

## Inputs

| input   | required | default   | description                   |
|---------|----------|-----------|-------------------------------|
| source  | **Yes**  | -         | Source Directory              |
| dest    | No       | `/static` | Destination Directory *       |
| host    | **Yes**  | -         | RSYNC Host                    |
| user    | **Yes**  | -         | RSYNC Host                    |
| pass    | **Yes**  | -         | RSYNC Host                    |
| port    | No       | `22`      | RSYNC Host                    |
| webhost | No       | -         | HTTP Web Host for URL *       |
| webhook | No       | -         | Discord Webhook *             |
| token   | No       | -         | `${{ secrets.GITHUB_TOKEN }}` |

**dest** - Remote destination directory should be the root of your web directory.
The full remote path will be {dest}/{owner}/{repo}/{run#}

**webhost** - Web host where the `dest` is available at. The full URL will be {webhost}/{owner}/{repo}/{run#}

**webhook** - A Discord Webhook URL that if provided will be posted to.

**token** - A GITHUB_TOKEN that if provided will be used to comment on the Pull Request.

For full details see: [scripts/run.sh](scripts%2Frun.sh)

```yaml
  - name: "Push Artifacts"
    uses: cssnr/push-artifacts-action@master
    with:
      source: "tests/screenshots"
      dest: "/static"
      host: ${{ secrets.RSYNC_HOST }}
      user: ${{ secrets.RSYNC_USER }}
      pass: ${{ secrets.RSYNC_PASS }}
      port: ${{ secrets.RSYNC_PORT }}
      webhost: "https://example.com"
      webhook: ${{ secrets.DISCORD_WEBHOOK }}
      token: ${{ secrets.GITHUB_TOKEN }}
```

### Examples

```yaml
name: "Push Artifacts Test"

on:
  push:
    branches:
      - master
  pull_request:
    branches:
      - master

jobs:
  test:
    name: "Test"
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - name: "Checkout"
        uses: actions/checkout@v4

      - name: "Push Artifacts"
        uses: cssnr/push-artifacts-action@master
        with:
          source: "tests/screenshots"
          dest: "/static"
          host: ${{ secrets.RSYNC_HOST }}
          user: ${{ secrets.RSYNC_USER }}
          pass: ${{ secrets.RSYNC_PASS }}
          port: ${{ secrets.RSYNC_PORT }}
          webhost: "https://example.com"
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
          token: ${{ secrets.GITHUB_TOKEN }}
```

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

Additionally, you can support other GitHub Actions I have created:

- [VirusTotal Action](https://github.com/cssnr/virustotal-action)
- [Update Version Tags Action](https://github.com/cssnr/update-version-tags-action)
- [Update JSON Value Action](https://github.com/cssnr/update-json-value-action)
- [Parse Issue Form Action](https://github.com/cssnr/parse-issue-form-action)
- [Portainer Stack Deploy](https://github.com/cssnr/portainer-stack-deploy-action)
- [Mozilla Addon Update Action](https://github.com/cssnr/mozilla-addon-update-action)

For a full list of current projects to support visit: [https://cssnr.github.io/](https://cssnr.github.io/)
