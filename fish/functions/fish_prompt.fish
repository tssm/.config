function fish_prompt
	echo
	switch $IN_NIX_SHELL
		case pure
			echo -n "🐡 "
		case impure
			echo -n "🐠 "
		case '*'
			echo -n "🐟 "
	end
end
