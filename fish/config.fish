set vimr /Applications/VimR.app/Contents/Resources/vimr
if [ -e $vimr ]
	set --export EDITOR $vimr
else
	set --export EDITOR nvim
end

# Nix
set NIX_LINK $HOME/.nix-profile
set --export NIX_PATH nixpkgs=$HOME/.nix-defexpr/channels/nixpkgs
set --export SSL_CERT_FILE $NIX_LINK/etc/ssl/certs/ca-bundle.crt

# XDG
if [ -z $XDG_CONFIG_HOME ]
	set --export XDG_CONFIG_HOME $HOME/.config
	set --export XDG_DATA_HOME $HOME/.local/share
	set --export XDG_CACHE_HOME $HOME/.cache
end

# NPM
set --export NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/config

# Python
set PYTHON_VERSION (find $NIX_LINK/lib -regex '.*/python[0-9]*\.[0-9]*' \
	| sort --version-sort \
	| tail -n 2)
set --export PYTHONPATH $NIX_LINK/lib/(basename $PYTHON_VERSION)/site-packages

set PATH $NIX_LINK/bin $NIX_LINK/sbin $PATH
set PATH ~/.local/bin $PATH
set PATH ~/.luarocks/bin $PATH
set PATH node_modules/.bin $XDG_DATA_HOME/node_modules $PATH
set --export PATH $PATH
