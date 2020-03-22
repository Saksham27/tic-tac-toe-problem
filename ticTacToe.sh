#!/bin/bash 

# baord
declare -a board
board=(1 2 3 4 5 6 7 8 9)
count=0
# start the game
for (( i=0; i<3; i++ ))
do
	for (( j=0; j<3; j++ ))
	do
		printf "| ${board[$count]} "
		((count++))
	done
		printf "|\n-------------\n"
done
