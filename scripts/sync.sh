#!/usr/bin/env bash
set -e

echo "GITHUB_REF_TYPE: ${GITHUB_REF_TYPE}"
echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_BASE_REF: ${GITHUB_BASE_REF}"
echo "GITHUB_HEAD_REF: ${GITHUB_HEAD_REF}"
echo "GITHUB_REF_NAME: ${GITHUB_REF_NAME}"

echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_RUN_NUMBER: ${GITHUB_RUN_NUMBER}"
echo "GITHUB_RUN_ATTEMPT: ${GITHUB_RUN_ATTEMPT}"

echo "INPUT_PATH: ${INPUT_PATH}"
echo "INPUT_HOST: ${INPUT_HOST}"
echo "INPUT_USER: ${INPUT_USER}"
echo "INPUT_PASS: ${INPUT_PASS}"  # hacked
echo "INPUT_PORT: ${INPUT_PORT}"
echo "INPUT_BASE: ${INPUT_BASE}"
echo "INPUT_WEBHOST: ${INPUT_WEBHOST}"
echo "INPUT_WEBHOOK: ${INPUT_WEBHOOK}"  # double hacked

REPO_RUN_PATH="${GITHUB_REPOSITORY}/${GITHUB_RUN_NUMBER}-${GITHUB_RUN_ATTEMPT}"
echo "REPO_RUN_PATH: ${REPO_RUN_PATH}"

mkdir -p "${GITHUB_REPOSITORY}"
mv "${INPUT_PATH}" "${REPO_RUN_PATH}"

python /scripts/gen_index.py "${REPO_RUN_PATH}" "${GITHUB_REPOSITORY}"

#SOURCE=$(dirname "${GITHUB_REPOSITORY}")
echo "SOURCE: ${GITHUB_REPOSITORY_OWNER}"
ls -lAhR "${GITHUB_REPOSITORY}"
echo "TARGET: ${INPUT_USER}@${INPUT_HOST}:${INPUT_BASE}/${REPO_RUN_PATH}"

sshpass -p "${INPUT_PASS}" \
rsync -aPvh -e "ssh -p ${INPUT_PORT} -o StrictHostKeyChecking=no" \
    "${GITHUB_REPOSITORY_OWNER}" "${INPUT_USER}@${INPUT_HOST}:${INPUT_BASE}"

if [ -n "${INPUT_WEBHOOK}" ];then
echo "Sending Discord Webhook"

URL="${INPUT_WEBHOST}/${REPO_RUN_PATH}/"
echo "URL: ${URL}"

echo "Running: discord.sh"
bash /scripts/discord.sh \
  --webhook-url="${INPUT_WEBHOOK}" \
  --username "ArtifactPush" \
  --avatar "https://avatars.githubusercontent.com/u/84293894?s=200&v=4" \
  --text "https://github.com/${GITHUB_ACTOR}\n${URL}" \
  --title "New Artifacts Pushed" \
  --description "**${GITHUB_REPOSITORY}**\n- ${GITHUB_REF_NAME}\n- Served Fresh" \
  --color "0xFFFFFF" \
  --url "${URL}" \
  --author "${GITHUB_ACTOR}" \
  --author-url "https://github.com/${GITHUB_ACTOR}" \
  --thumbnail "https://avatars.githubusercontent.com/u/84293894?s=200&v=4" \
  --timestamp
fi
