set --export EDITOR nvr -cc split --remote-wait-silent
set --export MANPAGER "nvr +Man! -"
set --export PAGER less --chop-long-lines --quit-if-one-screen --tabs=2

# Locale
set --export LANG en_GB.UTF-8
set --export LC_ALL $LANG

# XDG
set --export XDG_CACHE_HOME $HOME/.cache
set --export XDG_CONFIG_HOME $HOME/.config
set --export XDG_DATA_HOME $HOME/.local/share

# Nix
set --export NIX_PATH darwin-config=$XDG_CONFIG_HOME/darwin.nix:$HOME/.nix-defexpr/channels:$HOME/.nix-defexpr/channels_root
set --export NIX_PROFILES $HOME/.nix-profile /run/current-system/sw
set --export SSL_CERT_FILE $HOME/.nix-profile/etc/ssl/certs/ca-bundle.crt

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Postgres
set --export PSQLRC $XDG_CONFIG_HOME/psqlrc

# Readline
set --export INPUTRC $XDG_CONFIG_HOME/inputrc

for profile in $NIX_PROFILES
	set PATH $profile/bin $PATH
end
set PATH $HOME/.local/bin $PATH
set PATH ./node_modules/.bin $XDG_DATA_HOME/node_modules/bin $PATH
set --export PATH $PATH

# Local configuration
set local_config $XDG_CONFIG_HOME/fish/local-config.fish
if test -r $local_config
	source $local_config
end
