# Workflows

This is really just a POC...

## Push Artifacts

Will rsync a `path` (directory in the build) to `host`@`user` with `pass` on `port` to `base` remote directory
and append the `GITHUB_REPOSITORY` (org/repo) followed by `GITHUB_RUN_NUMBER` then `GITHUB_RUN_ATTEMPT`
and optionally send a notification to a Discord `webhook` prepending the `webhost` to the path.

### Variables

For more details see: [action.yaml](action.yaml)

| variable   | description                     |
|------------|---------------------------------|
| path:      | Local Path to Directory to sync |
| host:      | Remote rsync host               |             
| user:      | Remote rsync username           |             
| pass:      | $Remote rsync password          |             
| port:      | Remote rsync port number        |             
| base:      | Remote base directory to sync   |
| webhost:   | Remote web host for links       |             
| webhook:   | Discord Webhook to send alerts  |                  

### Example

```yaml
name: "Push Artifacts Test"

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
          path: "build/artifacts"
          host: ${{ secrets.RSYNC_HOST }}
          user: ${{ secrets.RSYNC_USER }}
          pass: ${{ secrets.RSYNC_PASS }}
          port: ${{ secrets.RSYNC_PORT }}
          base: "/static"
          webhost: "http://jammy.local:8000"
          webhook: ${{ secrets.DISCORD_WEBHOOK }}
```
