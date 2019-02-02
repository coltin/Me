mkdir -p ~/.logs/
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

export PATH=$PATH:~/bin

# Git Bash specific
alias sub='/c/Program\ Files/Sublime\ Text\ 3/subl.exe'
alias pip3-install='pip3 install --trusted-host ec2-35-165-134-231.us-west-2.compute.amazonaws.com'
alias pbcopy='clip'

# Enable AWS auto completion
complete -C '/c/Users/colti/AppData/Roaming/Python/Python36/Scripts/aws_completer' aws

# Generic Commands
alias g='./gradlew'
alias gits='git status'
alias gitpom='git push origin master'
alias git-how-many='git shortlog -s -n'
alias git-update='git checkout master;git pull'
alias git-amend='git add .;git commit --amend --no-edit'
alias git-log='git log --pretty=oneline --abbrev-commit'
alias git-log-author='git log --pretty=oneline --abbrev-commit'
alias git-log-me='git log --pretty=format:"%h %ad %s" --author="Coltin Caverhill" --date=short'
alias git-files='git diff --name-status'
alias git-discard='git checkout -- .; git submodule update'
alias git-remotes='git remote prune origin; git branch -r | grep coltin'
alias git-remote-delete='git push origin --delete'
alias git-delete-merged='git branch --merged master | grep -v master | xargs -I X git branch -D X'

function git-cleanse() {
    git branch | grep coltin/ | xargs -I X git branch -D X
    git remote prune origin
    git prune
    git fetch --prune
}

# This is where we add new things we want to learn.
function remember() {
    echo 'git rev-list master...HEAD'
    echo '   This will show all the different commits between master and HEAD'
}
alias breakpoint='echo "import pdb; pdb.set_trace()"'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if [ -f ~/bin/git-completion.bash ]; then
    . ~/bin/git-completion.bash
fi

function is-git-dir() {
    if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

function git-commits-this-month() {
    if is-git-dir; then
        MONTH=$1
        if [ -z $MONTH ]; then
            MONTH="$(date | awk '{print $2}')"
        fi
        git log | grep Date | grep 2017 | grep $MONTH | awk '{print $6,$3,$4}' | sort | uniq -c | awk '{sum += $1} END {print sum}'
    else
        echo "Not in a git directory"
    fi
}

function git_branch {
    if is-git-dir; then
        git branch --contains HEAD 2> /dev/null \
            | grep '*' \
            | head -n 1 \
            | cut -c 3- \
            | sed 's/^[ \(]*//;s/[ \)]*$//'
    fi
}

LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

RESET="\[\e[0m\]"
WHITE="\[\033[37;1m\]"
LIGHT_BLUE="\[\e[00;36m\]"
YELLOW="\[\e[00;33m\]"
GREEN="\[\e[00;32m\]"
export PS1="${LIGHT_BLUE}\W $(date "+%H:%M:%S")${YELLOW}[${GREEN}\$(git_branch)${YELLOW}]${WHITE}\\$ ${RESET}"

HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

HISTSIZE=10000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval $(ssh-agent)
ssh-add

cd ~/Code/boosted-insights-web-server/
