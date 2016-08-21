# aliases
alias ll="ls -al"
alias subl='open -a "Sublime Text 2"'
alias railsc="bin/rails c"
alias railss="bin/rails s"

# bash completion
if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

# loading for git branch in prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"

# custom prompt
export PS1="\u@\h \W \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# color = true
export CLICOLOR=1

# purty colors
export LSCOLORS=GxFxCxDxBxegedabagaced

# path
export PATH="/usr/local/bin:$PATH:/usr/local/m-cli"

# work config
eval "$(rbenv init -)"
export CH_USER="george"
#export CH_HIPCHAT_SECRET="{get from another developer}"
