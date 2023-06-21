#!/bin/bash

set -euo pipefail

# Fetch Liferay client-extension sample from
# https://github.com/liferay/liferay-portal/tree/master/workspaces/liferay-sample-workspace/client-extensions
# and place it in the current directory

# constants
CX_SAMPLES_GIT_REPO=${CX_SAMPLES_GIT_REPO:-'https://github.com/liferay/liferay-portal'}
CX_SAMPLES_GIT_REPO_BRANCH=${CX_SAMPLES_GIT_REPO_BRANCH:-'master'}
CX_SAMPLES_GIT_REPO_PATH=${CX_SAMPLES_GIT_REPO_PATH:-'workspaces/liferay-sample-workspace/client-extensions'}
GIT_EXECUTABLE=${GIT_EXECUTABLE:-'git'}
VERBOSE=${VERBOSE:-'false'}

usage() {
  local cx_samples_git_repo_human_url="${CX_SAMPLES_GIT_REPO}/tree/${CX_SAMPLES_GIT_REPO_BRANCH}/${CX_SAMPLES_GIT_REPO_PATH}"

  cat << EOF
Usage:
  get-cx-sample.sh <cx-sample-name>

For list of available samples, please open ${cx_samples_git_repo_human_url} in your browser.

ENV variables:
  CX_SAMPLES_GIT_REPO:          $CX_SAMPLES_GIT_REPO
    The base URL of source repo where the samples are located.
  CX_SAMPLES_GIT_REPO_BRANCH:   $CX_SAMPLES_GIT_REPO_BRANCH
    The branch of the repo where the samples are located.
  CX_SAMPLES_GIT_REPO_PATH:     $CX_SAMPLES_GIT_REPO_PATH
    The path in the repo where the samples are located.
  GIT_EXECUTABLE:               $GIT_EXECUTABLE
    The 'git' executable to be used fo fetch the files from git repo.
  VERBOSE:                      $VERBOSE
    Set to 'true' to echo the commands used to get the sample.
EOF
}

if ! ${GIT_EXECUTABLE} version; then
  echo "GIT_EXECUTABLE '${GIT_EXECUTABLE}' not found, wrong path?"
  ecit 2
fi

main() {
  # validate inputs
  local cx_sample_name=${1:-}

  if [[ -z $cx_sample_name ]]; then
    usage

    exit 1
  fi

  if [[ ${VERBOSE} == 'true' ]]; then
    set -x
#  else
#    exec &>/dev/null  # discard all output
  fi

  local git_sparse_checkout_path="${CX_SAMPLES_GIT_REPO_PATH}/${cx_sample_name}"
  local cx_samples_git_repo_clone_url="${CX_SAMPLES_GIT_REPO}.git" 	#

  local git_repo_clone_dir="liferay-portal.${cx_sample_name}.tmp"
  rm -rf "${git_repo_clone_dir}"

  # do a sparse checkout of liferay-portal repo (make it as fast as possible)
  "${GIT_EXECUTABLE}" clone --filter=blob:none --no-checkout --depth 1 --sparse "${cx_samples_git_repo_clone_url}" "${git_repo_clone_dir}"

  cd "${git_repo_clone_dir}"

  "${GIT_EXECUTABLE}" sparse-checkout add "${git_sparse_checkout_path}"
  "${GIT_EXECUTABLE}" checkout "${CX_SAMPLES_GIT_REPO_BRANCH}"

  local git_commit_hash_short=$("${GIT_EXECUTABLE}" rev-parse --short HEAD)

  cd ../

  # extract the cx directory to top level, with git hash being part of the final dir name
  local cx_target_dir="${cx_sample_name}@${git_commit_hash_short}"
  if [[ -d ${cx_target_dir} ]]; then
    cx_target_dir="${cx_target_dir}.$(date +%s)"
  fi

  if [[ ! -d "${git_repo_clone_dir}/${git_sparse_checkout_path}" ]]; then
    local cx_samples_git_repo_human_url="${CX_SAMPLES_GIT_REPO}/tree/${CX_SAMPLES_GIT_REPO_BRANCH}/${CX_SAMPLES_GIT_REPO_PATH}"

    cat << EOF

Looks like CX sample named '${cx_sample_name}' does not exist in the used git repo.
Make sure the target CX sample is present in the git repo: ${cx_samples_git_repo_human_url}
EOF

    rm -rf "${git_repo_clone_dir}"
    exit 3
  fi

  mv "${git_repo_clone_dir}/${git_sparse_checkout_path}" "${cx_target_dir}"
  rm -rf "${git_repo_clone_dir}"

  set +x
  cat << EOF

CX sample '${cx_sample_name}' fetched into directory ${cx_target_dir}/.
EOF
}

main "$@"