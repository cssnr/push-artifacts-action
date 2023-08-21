# Workflows

## Push Artifacts

Push Artifacts to SFTP Server.

```yaml
jobs:
  push-artifacts:
    uses: hosted-domains/workflows/.github/workflows/push-artifacts.yaml@master
    with:
      name: screenshots
#    secrets:
#      ftp-host: ${{ secrets.FTP_HOST }}
#      ftp-user: ${{ secrets.FTP_USER }}
#      ftp-pass: ${{ secrets.FTP_PASS }}
```
