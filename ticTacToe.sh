#!/bin/bash -x

# constants
PLAYER="O"
COMPUTER="X"
PLAYER_FIRST_MOVE=1  # so COMPUTER_FIRST_MOVE will be 0

# baord
declare -a board

# fucntion toss for deciding who will start the game
function toss() {
	echo $((RANDOM%2))
}

# function reset the board
function resetBoard() {
	board=(1 2 3 4 5 6 7 8 9)
}

# fucntion to display the board
function displayBoard() {
	count=0
	for (( i=0; i<3; i++ ))
	do
		for (( j=0; j<3; j++ ))
		do
			printf "| ${board[$count]} "
			((count++))
		done
			printf "|\n-------------\n"
	done
}

# ************** main program *****************

#start the game

resetBoard

tossResult=$( toss )
if [ $tossResult -eq 1 ]
then
	echo "player"
else
	echo "computer"
fi

