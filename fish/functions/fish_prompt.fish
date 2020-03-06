function fish_prompt
	echo
	switch $IN_NIX_SHELL
		case pure
			set_color green
			echo -n ">>> "
		case impure
			set_color yellow
			echo -n ">> "
		case '*'
			set_color cyan
			echo -n "> "
	end
	set_color normal
end
