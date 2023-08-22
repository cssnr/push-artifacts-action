# Workflows

## Push Artifacts

Push Artifacts to SFTP Server.

```yaml
jobs:
  push-artifacts:
    - name: "Push Artifacts"
      uses: hosted-domains/workflows/.github/workflows/action.yaml@master
      with:
        name: artifacts
        ftp-host: ${{ secrets.FTP_HOST }}
        ftp-user: ${{ secrets.FTP_USER }}
        ftp-pass: ${{ secrets.FTP_PASS }}
```
