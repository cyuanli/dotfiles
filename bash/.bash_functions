# yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Usage: wt <repo> <branch>   (e.g. wt core fix/foo)
# cd into worktree ~/git/worktrees/<repo>/<branch>, adding it if missing: local branch, else
# origin/<branch>, else new branch off origin/HEAD. Git refuses a branch checked out elsewhere.
wt() {
  if [ $# -ne 2 ]; then
    echo "usage: wt <repo> <branch>" >&2
    return 1
  fi
  local repo="$HOME/git/$1" branch="$2"
  local dir="$HOME/git/worktrees/$1/$branch"

  if [ -e "$dir/.git" ]; then
    cd "$dir"
    return
  fi

  git -C "$repo" fetch --quiet origin "$branch" 2>/dev/null

  if git -C "$repo" show-ref --quiet --verify "refs/heads/$branch" ||
    git -C "$repo" show-ref --quiet --verify "refs/remotes/origin/$branch"; then
    git -C "$repo" worktree add "$dir" "$branch" || return 1
  else
    # --no-track: upstream would otherwise be origin/master.
    git -C "$repo" worktree add --no-track -b "$branch" "$dir" origin/HEAD || return 1
  fi
  cd "$dir"
}

_wt_repos() {
  find "$HOME/git" -mindepth 2 -maxdepth 2 -name .git -printf '%h\n' | xargs -rn1 basename
}

_wt_branches() {
  {
    git -C "$HOME/git/$1" for-each-ref --format='%(refname:lstrip=2)' refs/heads
    git -C "$HOME/git/$1" for-each-ref --format='%(refname:lstrip=3)' refs/remotes/origin | grep -vx HEAD
  } 2>/dev/null | sort -u
}

if [ -n "$ZSH_VERSION" ]; then
  _wt() {
    case $CURRENT in
      2) compadd -- $(_wt_repos) ;;
      3) compadd -- $(_wt_branches "${words[2]}") ;;
    esac
  }
  command -v compdef >/dev/null && compdef _wt wt
else
  _wt() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    case $COMP_CWORD in
      1) COMPREPLY=($(compgen -W "$(_wt_repos)" -- "$cur")) ;;
      2) COMPREPLY=($(compgen -W "$(_wt_branches "${COMP_WORDS[1]}")" -- "$cur")) ;;
    esac
  }
  complete -F _wt wt
fi
