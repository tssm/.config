function fish_prompt
	set git_branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)
	set pijul_branch (pijul status 2> /dev/null \
		| head -n 1 \
		| grep --extended-regexp --only-matching '[^ ]+$')
			echo -n "on git's "
			echo -n $git_branch " "
		else if [ $pijul_branch ]
			set_color $fish_color_normal
			echo -n "on pijul's "
			set_color $fish_color_error
			echo -n $pijul_branch " "
	set home [ (pwd) = $HOME ]
	set remote [ -n "$SSH_CLIENT" -o -n "$SSH_CONNECTION" -o -n "$SSH_TTY" ]
	set sudo [ -n "$SUDO_USER" ]

	echo
	if $remote
		set_color $fish_color_user
		echo -n (whoami)
		set_color $fish_color_normal
		echo -n " at "
		set_color $fish_color_host
		echo -n (hostname | cut -d . -f 1)
		set_color $fish_color_normal
		echo -n " in "
		echo (pwd)
		echo -n "🚨 "
	else
		if $sudo
			set_color $fish_color_user
			echo -n (whoami)
			echo -n " "
		else
			if [ $IN_NIX_SHELL ]
				set_color $fish_color_user
				echo -n $IN_NIX_SHELL
				echo -n " nix-shell "
			end
		end
		if not $home
			set_color $fish_color_normal
			echo -n "in "
			set_color $fish_color_cwd
			echo -n (pwd)
			echo -n " "
		end
		if [ $git_branch ]
			set_color $fish_color_normal
			echo -n "on "
			set_color $fish_color_error
			echo -n $git_branch
			echo -n " "
		end
	end
	if test -n "$git_branch" || test -n "$pijul_branch" || not $home
		# Add a new line if the prompt has directory data
		echo
	end
	set_color cyan
	echo -n "» "
	set_color $fish_color_normal
end
