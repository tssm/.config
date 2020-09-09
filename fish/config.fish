set --export EDITOR nvim
set --export PAGER less --chop-long-lines --quit-if-one-screen --tabs=2

# Locale
set --export LANG en_GB.UTF-8
set --export LC_ALL $LANG

# XDG
set --export XDG_CACHE_HOME $HOME/.cache
set --export XDG_CONFIG_HOME $HOME/.config
set --export XDG_DATA_HOME $HOME/.local/share

# FZF
set --export FZF_DEFAULT_COMMAND 'fd --color always --exclude "*.enc" --ignore-file .pijulignore --hidden'
set --export FZF_DEFAULT_OPTS '--ansi --info inline --layout reverse --preview-window noborder'
set --export FZF_PREVIEW_COMMAND 'bat {}'

# Nix
set --export NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels
set --export NIX_PROFILES /nix/var/nix/profiles/default $HOME/.nix-profile
set --export SSL_CERT_FILE $HOME/.nix-profile/etc/ssl/certs/ca-bundle.crt

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Postgres
set --export PSQLRC $XDG_CONFIG_HOME/psqlrc

for profile in $NIX_PROFILES
	set PATH $profile/bin $PATH
end
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.luarocks/bin $PATH
set PATH ./node_modules/.bin $XDG_DATA_HOME/node_modules/bin $PATH
set --export PATH $PATH
