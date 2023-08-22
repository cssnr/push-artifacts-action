# Workflows

This is really just a POC...

## Push Artifacts

Will rsync a `path` (directory in the build) to `host`@`user` with `pass` on `port` to `base` remote directory
and append the `GITHUB_REPOSITORY` (org/repo) followed by `GITHUB_RUN_NUMBER` then `GITHUB_RUN_ATTEMPT`
and optionally send a notification to a Discord `webhook` prepending the `webhost` to the path.

```yaml
name: "Test"

on:
  push:

jobs:
  test:
    name: "Test"
    runs-on: ubuntu-latest
    timeout-minutes: 5

    steps:
      - name: "Checkout"
        uses: actions/checkout@v3

      - name: "Push Artifacts"
        uses: hosted-domains/gh-push-artifacts@master
        with:
          path: "examples"
          host: ${{ secrets.RSYNC_HOST }}
          user: ${{ secrets.RSYNC_USER }}
          pass: ${{ secrets.RSYNC_PASS }}
          port: "2222"
          base: "/static"
          webhost: "http://jammy.local:8000"
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
```
