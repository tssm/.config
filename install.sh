#!/usr/bin/env sh

ln -s ~/.config/ghci ~/.ghci
mkdir -p ~/.cache/psql_history

# Neovim

NVIM_SPELL_DEST=~/.local/share/nvim/site/spell/
NVIM_SPELL_EXTENSION=.utf-8.spl
NVIM_SPELL_SOURCE=http://ftp.vim.org/vim/runtime/spell/

mkdir -p ${NVIM_SPELL_DEST}

for l in en es; do
	curl ${NVIM_SPELL_SOURCE}${l}${NVIM_SPELL_EXTENSION} \
		--output ${NVIM_SPELL_DEST}${l}${NVIM_SPELL_EXTENSION}
done
