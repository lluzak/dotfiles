install: install-packages install-vim install-zsh install-rubygems install-submodules install-tmux install-git install-rbenv install-ruby-build install-zsh-plugins install-nvm

install-packages:
	sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libpq-dev postgresql-9.3
	sudo apt-get install -y mercurial libncurses-dev zsh curl git tmux

install-submodules:
	git submodule init
	git submodule update

install-nvm:
	curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash

linking:
	ln -fs `pwd`/zshrc ~/.zshrc
	ln -fs `pwd`/gemrc ~/.gemrc
	ln -fs `pwd`/gitconfig ~/.gitconfig
	ln -fs `pwd`/oh-my-zsh/themes ~/.oh-my-zsh/custom/themes

install-tmux:
	ln -fs `pwd`/tmux.conf ~/.tmux.conf
