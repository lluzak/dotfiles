install: install-packages install-vim install-zsh install-rubygems install-submodules install-tmux install-git install-rbenv install-ruby-build install-zsh-plugins install-nvm

install-packages:
	sudo apt-get install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libpq-dev postgresql-9.3
	sudo apt-get install -y mercurial libncurses-dev zsh curl git tmux

install-submodules:
	git submodule init
	git submodule update

install-nvm:
	curl https://raw.githubusercontent.com/creationix/nvm/v0.13.1/install.sh | bash

install-vim:
	hg clone https://vim.googlecode.com/hg/ ~/vim
	mkdir ~/.tmp
	cd ~/vim && ./configure --enable-rubyinterp --with-features=huge
	cd ~/vim && sudo make install -j 8
	ln -fs `pwd`/vimrc ~/.vimrc
	ln -fs `pwd`/vim ~/.vim

install-rbenv:
	git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

install-ruby-build:
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

install-zsh:
	curl -L http://install.ohmyz.sh | sh
	ln -fs `pwd`/zshrc ~/.zshrc

install-rubygems:
	ln -fs `pwd`/gemrc ~/.gemrc

install-tmux:
	ln -fs `pwd`/tmux.conf ~/.tmux.conf

install-git:
	ln -fs `pwd`/gitconfig ~/.gitconfig
	mkdir -p ~/.git
	ln -fs `pwd`/gitconfig ~/.git/config

install-zsh-plugins:
	ln -fs `pwd`/oh-my-zsh/plugins/prog_helper ~/.oh-my-zsh/custom/plugins
