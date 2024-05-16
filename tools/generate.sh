#!/bin/zsh


guilds=(
	'kor 564121831'
	'villains-1 494244761'
	'anarchy 728164266'
	'villains-2 656144574'
	'villains-3 164111865'
	'villains-4 167294499'
	'villains-7 862655434'
	'villains-5 184799421'
)

# prime the pipe -- fetch the first guild
echo "==============="
echo "FETCH: $guilds[1]"
args=("${(@s/ /)guilds[1]}")

echo "~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json"
time ~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json || exit 1


for ((i = 1; i < $#guilds; i++)) ; do 
	args=("${(@s/ /)guilds[i]}")
	
	# now build the guild we just fetched
	echo "~/bin/swgoh-tool site-guild --kor --guild $args[1].json --output docs"
	time ~/bin/swgoh-tool site-guild --kor --guild $args[1].json --output docs &
	
	# and fetch the next one
	
	echo "==============="
	args=("${(@s/ /)guilds[i + 1]}")
	echo "FETCH: $args"

	echo "~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json"
	time ~/bin/swgoh-tool fetch --id $args[2] --guild $args[1].json || exit 1
	
	# wait for both to complete
	wait
	
done

# finish the pipeline
args=("${(@s/ /)guilds[$#guilds]}")
echo "~/bin/swgoh-tool site-guild --kor --guild $args[1].json --output docs"
time ~/bin/swgoh-tool site-guild --kor --guild $args[1].json --output docs &

echo "==============="
echo "ALLIANCE"

time ~/bin/swgoh-tool site-alliance --kor --output docs --guilds *.json

wait

ret=$?; times; exit "$ret"
