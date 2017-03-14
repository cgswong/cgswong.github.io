#!/bin/bash
# DESC: Generate and deploy website using Hugo to personal GitHub Pages repository.

# Branch containinig source files
GIT_SRC_BRANCH="hugo"
# Branch containinig destination files
GIT_DST_BRANCH="master"
# Git destination directory
GIT_DST_DIR="public"
# GitHub personal repository name
GIT_USERNAME=cgswong
# Commit message
GIT_MSG="Rebuilding site $(date)"

log() {
  echo -e "\033[1;32m${1}\033[0m"
}

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

log "Pulling down the \`${GIT_SRC_BRANCH}\` branch into \`${GIT_DST_DIR}\` to help avoid merge conflicts"
git subtree pull --prefix=${GIT_DST_DIR} git@github.com:${GIT_USERNAME}/${GIT_USERNAME}.github.io.git ${GIT_SRC_BRANCH} -m "Merge master"


log "Building the website."
hugo

log "Pushing the updated \`${GIT_DST_DIR}\` folder to the \`${GIT_SRC_BRANCH}\` branch"
git add public
[[ $# -eq 1 ]] && GIT_MSG="$1"
git commit -m "${GIT_MSG}"
git push origin "${GIT_SRC_BRANCH}"

log "Pushing the updated \`${GIT_DST_DIR}\` folder to the \`${GIT_DST_BRANCH}\` branch"
git subtree push --prefix=${GIT_DST_DIR} git@github.com:${GIT_USERNAME}/${GIT_USERNAME}.github.io.git ${GIT_SRC_BRANCH}
