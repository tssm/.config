install:
	echo source ~/.config/bash/profile >> ~/.bash_profile
	echo source ~/.config/bash/bashrc >> ~/.bash_profile
	ln -s ~/.config/ghci ~/.ghci
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
		bash git inputrc Makefile nvim $(MACHINE):.config
