set --export EDITOR nvr
set --export PAGER less --chop-long-lines --quit-if-one-screen --tabs=2

# Locale
set --export LANG en_GB.UTF-8
set --export LC_ALL $LANG

# Nix
set NIX_LINK $HOME/.nix-profile
set --export NIX_PATH darwin-config=$XDG_CONFIG_HOME/darwin.nix:$HOME/.nix-defexpr/channels
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

# Readline
set --export INPUTRC $XDG_CONFIG_HOME/inputrc

# Ripgrep
set --export RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgreprc

set PATH /run/current-system/sw/bin $PATH
set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.luarocks/bin $PATH
set PATH ./node_modules/.bin $XDG_DATA_HOME/node_modules/bin $PATH
set --export PATH $PATH

# Local configuration
set local_config $XDG_CONFIG_HOME/fish/local-config.fish
if test -r $local_config
	source $local_config
end
