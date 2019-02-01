install:
	ln -s ~/.config/ghci ~/.ghci
	ln -s ~/.config/nvim/init.vim ~/.ideavimrc
	ln -s ~/.config/psqlrc ~/.psqlrc
	mkdir -p ~/.cache/psql_history

.PHONY: distribute
distribute:
	rsync\
		--archive\
		--verbose\
		--delete\
		bash git inputrc Makefile nvim $(MACHINE):.config
