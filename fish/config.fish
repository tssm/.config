set vimr /Applications/VimR.app/Contents/Resources/vimr
if [ -e $vimr ]
	set --export EDITOR $vimr
	set --export GIT_EDITOR $vimr --wait --nvim
else
	set --export EDITOR nvim
end

# XDG
set --export XDG_CACHE_HOME $HOME/.cache
set --export XDG_CONFIG_HOME $HOME/.config
set --export XDG_DATA_HOME $HOME/.local/share

# Nix
set --export NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels
set --export NIX_PROFILES /nix/var/nix/profiles/default $HOME/.nix-profile
set --export SSL_CERT_FILE $HOME/.nix-profile/etc/ssl/certs/ca-bundle.crt

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Postgres
set --export PSQLRC $XDG_CONFIG_HOME/psqlrc

# Python
set PYTHON_VERSION (find $NIX_LINK/lib -regex '.*/python[0-9]*\.[0-9]*' \
	| sort --version-sort \
	| tail -n 2)
set --export PYTHONPATH $NIX_LINK/lib/(basename $PYTHON_VERSION)/site-packages

for profile in $NIX_PROFILES
	set PATH $profile/bin $PATH
end
set PATH $HOME/.local/bin $PATH
set PATH $HOME/.luarocks/bin $PATH
set PATH ./node_modules/.bin $XDG_DATA_HOME/node_modules/bin $PATH
set --export PATH $PATH
