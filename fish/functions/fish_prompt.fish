function fish_prompt
	set git_branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)
	set home [ (pwd) = $HOME ]
	set remote [ -n "$SSH_CLIENT" -o -n "$SSH_CONNECTION" -o -n "$SSH_TTY" ]

	echo
	set_color $fish_color_user
	echo -n (whoami)
	if $remote
		set_color $fish_color_normal
		echo -n " at "
		set_color $fish_color_host
		echo -n (hostname | cut -d . -f 1)
	end
	if not $home
		set_color $fish_color_normal
		echo -n " in "
		set_color $fish_color_cwd
		echo -n (pwd)
	else
		echo -n " "
	end
	if [ $git_branch ]
		set_color $fish_color_normal
		echo -n " on "
		set_color magenta
		echo -n $git_branch
	end
	if not $home
		echo
	end
	if $remote
		echo -n "🚨 "
	else
		set_color cyan
		echo -n "» "
	end
	set_color $fish_color_normal
end
