install:
	curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs\
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	echo source ~/.config/bash/profile >> ~/.bash_profile
	echo source ~/.config/bash/bashrc >> ~/.bash_profile
	ln -s ~/.config/ctags ~/.ctags
	ln -s ~/.config/nvim/init.vim ~/.ideavimrc
	ln -s ~/.config/inputrc ~/.inputrc
	ln -s ~/.config/psqlrc ~/.psqlrc
	mkdir -p ~/.cache/psql_history

.PHONY: distribute
distribute:
	rsync\
		--archive\
		--verbose\
		--delete\
		bash git inputrc Makefile nvim/init.vim nvim/templates $(MACHINE):.config
