# Workflows

## Push Artifacts

Push Artifacts to SFTP Server.

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
          path: "artifacts"
```
