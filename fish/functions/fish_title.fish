function fish_title
	set command (status current-command)
	if [ $command = "man" ]
		set parts (string split " " -- $argv)
		echo manual for $parts[2]
	else
		echo $command "in" (pwd)
	end
end
