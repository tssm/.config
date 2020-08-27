# Locale
set --export LANG en_GB.UTF-8
set --export LC_ALL $LANG

# Neovim
set --local neovim_guis \
	/Applications/FVim.app/Contents/MacOS/FVim \
	/Applications/goneovim.app/Contents/MacOS/goneovim

set --export EDITOR $neovim_guis[(random 1 2)]

# Nix
set NIX_LINK $HOME/.nix-profile
set --export NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
set --export SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt

# XDG
if test -z $XDG_CONFIG_HOME
	set --export XDG_CONFIG_HOME $HOME/.config
	set --export XDG_DATA_HOME $HOME/.local/share
	set --export XDG_CACHE_HOME $HOME/.cache
end

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Postgres
set --export PSQLRC $XDG_CONFIG_HOME/psqlrc

set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.luarocks/bin $PATH
set PATH ./node_modules/.bin $XDG_DATA_HOME/node_modules/bin $PATH
set --export PATH $PATH
