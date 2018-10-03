# aliases
alias ll="ls -al"
alias subl='open -a "Sublime Text 2"'
alias railsc="bin/spring stop && bin/rails console"
alias railss="bin/rails s"
alias be="bundle exec"
alias ber="bundle exec rake"
alias bert="bundle exec rake test"
alias vim="nvim"
alias vscode="open . -a 'Visual Studio Code'"

# one medical aliases
alias qualconsole="beans exec rails console --interactive -a $QUAL_SERVER_NAME -i ~/.ssh/1life-core.pem"
alias qualdeploy="beans deploy -a $QUAL_SERVER_NAME"
alias qualmigrate="beans exec rake db:migrate -a $QUAL_SERVER_NAME"
alias docker_attach_onelife="docker attach $(docker ps | grep 'onelife-base' | awk '{print $1;}')"
alias docker_attach_onelifeui="docker attach $(docker ps | grep 'onelife-ui' | awk '{print $1;}')"
alias docker_update_node_modules="docker-compose run onelife-ui npm prune && npm i"

# bash completion
if [ -f $HOME/.git-completion.bash ]; then
  . $HOME/.git-completion.bash
fi

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# one medical vars
export QUAL_SERVER_NAME="onelife-paris"

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

# editor
export VISUAL=vim
export EDITOR="$VISUAL"

# initialize ruby and node version managers
eval "$(rbenv init -)"
eval "$(nodenv init -)"

# load fzf bash
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
