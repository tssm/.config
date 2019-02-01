nvim_spell_dest = ~/.local/share/nvim/site/spell/
nvim_spell_extension = .utf-8.spl
nvim_spell_source = http://ftp.vim.org/vim/runtime/spell/

install:
	ln -s ~/.config/ghci ~/.ghci
	ln -s ~/.config/nvim/init.vim ~/.ideavimrc
	ln -s ~/.config/psqlrc ~/.psqlrc
	mkdir -p ~/.cache/psql_history
	# Neovim spell
	mkdir -p $(nvim_spell_dest)
	curl $(nvim_spell_source)en$(nvim_spell_extension) \
		--output $(nvim_spell_dest)en$(nvim_spell_extension)
	curl $(nvim_spell_source)es$(nvim_spell_extension) \
		--output $(nvim_spell_dest)es$(nvim_spell_extension)

.PHONY: distribute
distribute:
	rsync\
		--archive\
		--verbose\
		--delete\
		bash git inputrc Makefile nvim $(MACHINE):.config
