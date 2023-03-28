#!/usr/bin/env bash

function fzf_git_worktree_change_dir() {
  local worktrees
  local worktree
  local query
  local sess_arr
  local retval
  worktrees=$(git worktree list | fzf --exit-0 --print-query --reverse)
  retval=$?

  IFS=$'\n' read -rd '' -a sess_arr <<<"$worktrees"

  worktree=$(echo ${sess_arr[1]} | awk '{print $1}')
  query=${sess_arr[0]}

  if [ $retval == 0 ]; then
    if [ "$worktree" == "" ]; then
      worktree=$(echo "$query" | awk '{print $1}')
    fi
    cd "$worktree"
  elif [ $retval == 1 ]; then
    DEFAULT_GIT_FOLDER=$(git worktree list | head --lines 1 | awk '{print $1}')

    mkdir $DEFAULT_GIT_FOLDER/.worktrees

    git worktree add $DEFAULT_GIT_FOLDER/.worktrees/"$query"

    cd $DEFAULT_GIT_FOLDER/.worktrees/"$query"

    git branch "$query"
    git checkout "$query"
  fi
}

function fzf_git_worktree_remove() {
  WORKTREE=$(git worktree list | fzf | awk '{print $1}')
  DEFAULT_GIT_FOLDER=$(git worktree list | head --lines 1 | awk '{print $1}')

  git worktree remove $WORKTREE --force &>/dev/null
  cd $DEFAULT_GIT_FOLDER
}
