# aliases
alias ll="ls -al"
alias subl='open -a "Sublime Text 2"'
alias railsc="bin/spring stop && bin/rails console"
alias railss="bin/rails s"
alias be="bundle exec"
alias ber="bundle exec rake"
alias bert="bundle exec rake test"

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

# coverhound admin
export CH_USER="george@coverhound.com"

# work config
eval "$(rbenv init -)"
eval "$(nodenv init -)"
