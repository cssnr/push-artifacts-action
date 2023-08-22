#!/usr/bin/env bash
#set -e

echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_RUN_NUMBER: ${GITHUB_RUN_NUMBER}"
echo "GITHUB_RUN_ATTEMPT: ${GITHUB_RUN_ATTEMPT}"

echo "INPUT_PATH: ${INPUT_PATH}"
echo "INPUT_HOST: ${INPUT_HOST}"
echo "INPUT_USER: ${INPUT_USER}"
echo "INPUT_PASS: ${INPUT_PASS}"  # hacked
echo "INPUT_PORT: ${INPUT_PORT}"
echo "INPUT_BASE: ${INPUT_BASE}"

REPO_RUN_PATH="${GITHUB_REPOSITORY}/${GITHUB_RUN_NUMBER}-${GITHUB_RUN_ATTEMPT}"
echo "REPO_RUN_PATH: ${REPO_RUN_PATH}"

mkdir -p "${GITHUB_REPOSITORY}"
mv "${INPUT_PATH}" "${REPO_RUN_PATH}"

#SOURCE=$(dirname "${GITHUB_REPOSITORY}")
echo "SOURCE: ${GITHUB_REPOSITORY_OWNER}"
ls -lAhR "${GITHUB_REPOSITORY}"
echo "TARGET: ${INPUT_USER}@${INPUT_HOST}:${INPUT_BASE}/${REPO_RUN_PATH}"

sshpass -p "${INPUT_PASS}" \
rsync -aPvh -e "ssh -p ${INPUT_PORT} -o StrictHostKeyChecking=no" \
    "${GITHUB_REPOSITORY_OWNER}" "${INPUT_USER}@${INPUT_HOST}:${INPUT_BASE}"

if [ -n "${INPUT_WEBHOOK}" ];then

URL="${INPUT_WEBHOST}/${REPO_RUN_PATH}"

_description="""
**${GITHUB_REPOSITORY}**
New Artifacts Pushed =)
[${URL}](${URL})
"""

bash discord.sh \
  --webhook-url="${INPUT_WEBHOOK}" \
  --username "ArtifactPush" \
  --avatar "https://i.imgur.com/12jyR5Q.png" \
  --text "${URL}" \
  --title "New Artifacts Pushed" \
  --description "${_description}" \
  --color "0xFFFFFF" \
  --url "${URL}" \
  --author "${GITHUB_ACTOR}" \
  --author-url "https://github.com/${GITHUB_REPOSITORY}" \
  --timestamp

fi
