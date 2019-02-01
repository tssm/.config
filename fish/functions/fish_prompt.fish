function fish_prompt
	set git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
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
			set_color magenta
			echo -n $git_branch
			echo -n " "
		end
	end
	if test -n "$git_branch" || not $home
		echo
	end
	set_color cyan
	echo -n "» "
	set_color $fish_color_normal
end
