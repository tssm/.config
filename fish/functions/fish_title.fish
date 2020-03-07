function fish_title
	set command (status current-command)
	switch $command
		case fish
			echo fish in (pwd)
		case man
			echo manual for (string split ' ' $argv)[-1]
		case '*'
			echo $command
	end
end
