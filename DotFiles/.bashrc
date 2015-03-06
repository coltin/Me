# Returns your current branch. If you are not in a git repo, will return "not repo" which is super boring.
function git_branch {
  # This checks if we are currently in a git repo, suppressing stdin and stderr.
	if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
		# Gets the current branches that are at HEAD.
		# Selects the actual branch with '*' hack.
		# Makes sure we only get 1 line with `head` due to paranoia.
		# Removes trailing 3 characters " * ". So " * master" -> "master"
		# Removes "(" from the start and ")" from the end with `sed`.
		#  - This is for "(detached from f83fe38)", we don't want the parenthesis.
		git branch --contains HEAD \
			| grep '*' \
			| head -n 1 \
			| cut -c 3- \
			| sed 's/^[ \(]*//;s/[ \)]*$//'
	else
		echo 'not repo'
	fi
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
