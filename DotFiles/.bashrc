# This function will try to best guess at your current branch. If you are in a detached head state results may vary.
function git_branch {
  [ -d .git ] && git name-rev --name-only @
}

#Defines some colors for PS1 prompt
RESET="\[\e[0m\]"
WHITE="\[\033[37;1m\]"
LIGHT_BLUE="\[\e[00;36m\]"
YELLOW="\[\e[00;33m\]"
GREEN="\[\e[00;32m\]"

# Sets your prompt such that if you are in ~/Code/workspace/android which has a git repo
# on branch "some_branch" your prompt will be, without quotes:
# "android[some_branch]$ "
export PS1="${LIGHT_BLUE}\W${WHITE}: ${YELLOW}[${GREEN}\$(git_branch)${YELLOW}]${WHITE}\\$ ${RESET}"
