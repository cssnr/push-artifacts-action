#!/usr/bin/env bash

set -e

echo "Running: ${0} as: $(whoami) in: $(pwd)"

echo "---------- GITHUB ----------"

echo "GITHUB_REF: ${GITHUB_REF}"
echo "GITHUB_BASE_REF: ${GITHUB_BASE_REF}"
echo "GITHUB_HEAD_REF: ${GITHUB_HEAD_REF}"
echo "GITHUB_REF_NAME: ${GITHUB_REF_NAME}"
echo "GITHUB_REPOSITORY: ${GITHUB_REPOSITORY}"
echo "GITHUB_RUN_NUMBER: ${GITHUB_RUN_NUMBER}"
echo "GITHUB_RUN_ATTEMPT: ${GITHUB_RUN_ATTEMPT}"

REPO="${GITHUB_REPOSITORY#*/}"
echo "REPO: ${REPO}"
OWNER="${GITHUB_REPOSITORY_OWNER}"
echo "OWNER: ${OWNER}"

echo "---------- INPUTS ----------"

[[ -n "${INPUT_PATH}" ]] && INPUT_SOURCE="${INPUT_PATH}"  # backwards compatibility
echo "INPUT_SOURCE: ${INPUT_SOURCE}"
[[ -n "${INPUT_BASE}" ]] && INPUT_DEST="${INPUT_BASE}"  # backwards compatibility
echo "INPUT_DEST: ${INPUT_DEST}"
echo "INPUT_HOST: ${INPUT_HOST}"
echo "INPUT_USER: ${INPUT_USER}"
#echo "INPUT_PASS: ${INPUT_PASS}"  # hacked
echo "INPUT_PORT: ${INPUT_PORT}"
echo "INPUT_WEBHOST: ${INPUT_WEBHOST}"
#echo "INPUT_WEBHOOK: ${INPUT_WEBHOOK}"  # hacked
echo "INPUT_COMMENT: ${INPUT_COMMENT}"
#echo "INPUT_TOKEN: ${INPUT_TOKEN}"  # hacked
[[ -n ${INPUT_TOKEN} ]] && export GH_TOKEN="${INPUT_TOKEN}"

echo "----------  SYNC  ----------"

REPO_RUN_PATH="${GITHUB_REPOSITORY}/${GITHUB_RUN_NUMBER}-${GITHUB_RUN_ATTEMPT}"
echo "REPO_RUN_PATH: ${REPO_RUN_PATH}"

echo "Moving INPUT_SOURCE: ${INPUT_SOURCE} to REPO_RUN_PATH: ${REPO_RUN_PATH}"
mkdir -p "${GITHUB_REPOSITORY}"
mv "${INPUT_SOURCE}" "${REPO_RUN_PATH}"

echo "Running: /src/generate.py"
python /src/generate.py "${REPO_RUN_PATH}" "${GITHUB_REPOSITORY}"

echo "Listing Source Directory: ${GITHUB_REPOSITORY_OWNER}"
ls -lAhR "${GITHUB_REPOSITORY_OWNER}"

echo "rsync from: ${GITHUB_REPOSITORY_OWNER} to: ${INPUT_USER}@${INPUT_HOST}:${INPUT_DEST}"
sshpass -p "${INPUT_PASS}" \
    rsync -aPvh -e "ssh -p ${INPUT_PORT} -o StrictHostKeyChecking=no" \
    "${GITHUB_REPOSITORY_OWNER}" "${INPUT_USER}@${INPUT_HOST}:${INPUT_DEST}"

echo "----------  POST  ----------"

# TODO: Add cleanup to move INPUT_SOURCE back and delete index.html

URL="${INPUT_WEBHOST}/${REPO_RUN_PATH}/"
echo "URL: ${URL}"
MD_URL="[${GITHUB_REPOSITORY}](${URL})"
echo "MD_URL: ${MD_URL}"
MD_REFS="- ${GITHUB_REF_NAME:-None}\n- ${GITHUB_HEAD_REF:-None}"
echo -e "MD_REFS:\n${MD_REFS}"

if [[ ${GITHUB_REF} =~ refs/pull/[0-9]+/merge ]]; then
    PR_NUMBER=$(echo "${GITHUB_REF}" |  sed 's/refs\/pull\/\([0-9]\+\)\/merge/\1/')
    echo "PR_NUMBER: ${PR_NUMBER}"
fi

if [ -n "${PR_NUMBER}" ] && [ "${INPUT_COMMENT}" == "true" ];then
    echo -e "\u001b[34;1mCommenting on PR: ${PR_NUMBER}"
    echo -e "Screen Shots Link: ${MD_URL}\n${MD_REFS}" > /tmp/body
    git config --global --add safe.directory "${GITHUB_WORKSPACE}"
    declare commented
    gh pr view "${PR_NUMBER}" --json comments | jq -c '.comments[]' | while read -r comment; do
        login=$(echo "${comment}" | jq -r '.author.login')
        if [ "${login}" == "github-actions" ];then
            body=$(echo "${comment}" | jq -r '.body')
            if [[ ${body} == Screen\ Shots\ Link:* ]]; then
                comment_id=$(echo "${comment}" | jq -r '.id')
                comment_url="/repos/${OWNER}/${REPO}/pulls/comments/${comment_id}"
                echo "Editing existing comment at: ${comment_url}"
                gh api --method PATCH -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "${comment_url}" -f "body=$(cat /tmp/body)"
                #gh api --method PATCH "${comment_url}" f body="$(cat /tmp/body)"
                #gh pr comment "${PR_NUMBER}" --body-file /tmp/body
                commented="yes"
                break
            fi
        fi
    done
    if [ "${commented}" != "yes" ];then
        echo "Adding new comment."
        gh pr comment "${PR_NUMBER}" --body-file /tmp/body
    fi
else
    echo -e "\u001b[33mSkipping comment because not PR or comment: \u001b[0m${INPUT_COMMENT}"
fi

if [ -n "${INPUT_WEBHOOK}" ];then
    echo -e "\u001b[34;1mSending Discord Webhook"
    echo "bash /src/discord.sh"
    bash /src/discord.sh \
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
    echo -e "\u001b[33;1mSkipping Webhook post because no webhook input"
fi

echo -e "\u001b[32;1mFinished Success."
