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

echo "---------- INPUTS ----------"
#echo "INPUT_TOKEN: ${INPUT_TOKEN}"  # hacked
echo "INPUT_SOURCE: ${INPUT_SOURCE}"
echo "INPUT_DEST: ${INPUT_DEST}"
echo "INPUT_HOST: ${INPUT_HOST}"
echo "INPUT_USER: ${INPUT_USER}"
#echo "INPUT_PASS: ${INPUT_PASS}"  # hacked
echo "INPUT_PORT: ${INPUT_PORT}"
# shellcheck disable=SC2153
echo "INPUT_WEBHOST: ${INPUT_WEBHOST}"
#echo "INPUT_WEBHOOK: ${INPUT_WEBHOOK}"  # hacked
echo "---------- INPUTS ----------"

[[ -n ${INPUT_TOKEN} ]] && export GH_TOKEN="${INPUT_TOKEN}"

REPO_RUN_PATH="${GITHUB_REPOSITORY}/${GITHUB_RUN_NUMBER}-${GITHUB_RUN_ATTEMPT}"
echo "REPO_RUN_PATH: ${REPO_RUN_PATH}"

echo "Moving INPUT_SOURCE: ${INPUTPATH} to REPO_RUN_PATH: ${REPO_RUN_PATH}"
mkdir -p "${GITHUB_REPOSITORY}"
mv "${INPUT_SOURCE}" "${REPO_RUN_PATH}"

echo "Running: /scripts/gen_index.py"
python /scripts/gen_index.py "${REPO_RUN_PATH}" "${GITHUB_REPOSITORY}"

echo "Listing Source Directory: ${GITHUB_REPOSITORY_OWNER}"
ls -lAhR "${GITHUB_REPOSITORY_OWNER}"

echo "rsync from: ${GITHUB_REPOSITORY_OWNER} to: ${INPUT_USER}@${INPUT_HOST}:${INPUT_DEST}"
sshpass -p "${INPUT_PASS}" \
    rsync -aPvh -e "ssh -p ${INPUT_PORT} -o StrictHostKeyChecking=no" \
    "${GITHUB_REPOSITORY_OWNER}" "${INPUT_USER}@${INPUT_HOST}:${INPUT_DEST}"

URL="${INPUT_WEBHOST}/${REPO_RUN_PATH}/"
echo "URL: ${URL}"
MD_URL="[${GITHUB_REPOSITORY}](${URL})"
echo "MD_URL: ${MD_URL}"
MD_REFS="- ${GITHUB_REF_NAME:-None}\n- ${GITHUB_HEAD_REF:-None}"
echo -e "MD_REFS:\n${MD_REFS}"

PR_NUMBER=$(echo "${GITHUB_REF}" | sed 's/refs\/pull\/\([0-9]\+\)\/.*/\1/')
echo "PR_NUMBER: ${PR_NUMBER}"

if [ -n "${PR_NUMBER}" ] && [ -n "${GH_TOKEN}" ];then
    echo "Commenting on PR: ${PR_NUMBER}"
    echo -e "Screen Shots Link: ${MD_URL}\n${MD_REFS}" > /tmp/body
    gh pr comment "${PR_NUMBER}" --body-file /tmp/body
else
    echo "----- Skipping PR Comment because not PR or no GH_TOKEN"
fi

if [ -n "${INPUT_WEBHOOK}" ];then
    echo "Sending Discord Webhook"

    echo "bash /scripts/discord.sh"
    bash /scripts/discord.sh \
      --webhook-url="${INPUT_WEBHOOK}" \
      --username "ArtifactPush" \
      --avatar "https://avatars.githubusercontent.com/u/84293894?s=200&v=4" \
      --text "${URL}\n<https://github.com/${GITHUB_REPOSITORY}>" \
      --title "New Artifacts Pushed" \
      --description "**${GITHUB_REPOSITORY}**\n${MD_REFS}" \
      --color "0xFFFFFF" \
      --url "${URL}" \
      --author "${GITHUB_ACTOR}" \
      --author-url "https://github.com/${GITHUB_ACTOR}" \
      --thumbnail "https://avatars.githubusercontent.com/u/84293894?s=200&v=4" \
      --timestamp
else
    echo "----- Skipping Webhook Comment because no webhook input"
fi

echo "Finished Success."
