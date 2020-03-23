#!/bin/bash -x

# constants
BOARD_SIZE=3
PLAYER="O"
COMPUTER="X"
COUNT=1
PLAYER_FIRST_MOVE=1  # so COMPUTER_FIRST_MOVE will be 0
NO_WINNER=0
# variables
winner=0
chance=1

# baord
declare -A board

# fucntion toss for deciding who will start the game
function toss() {
	temp=$((RANDOM%2))
	if [ $temp -eq 1 ]
	then
		echo "player"
	else
		echo "computer"
	fi
}

# function reset the board
function resetBoard() {
	count=$COUNT
	for (( i=0; i<$BOARD_SIZE; i++ ))
	do
		for (( j=0; j<$BOARD_SIZE; j++ ))
		do
			board[$i,$j]="."
			((count++))
		done
	done
}

# fucntion to display the board
function displayBoard() {
	for (( i=0; i<$BOARD_SIZE; i++ ))
	do
		for (( j=0; j<$BOARD_SIZE; j++ ))
		do
			printf "| ${board[$i,$j]} "
		done
			printf "|\n-------------\n"
	done
}

# function to check win , tie or next move
# 1 2 3
# 4 5 6
# 7 8 9
function checkWin() {
	if [ $winner -eq $NO_WINNRER ]
	then
		for (( i=0; i<$BOARD_SIZE; i++ ))
		do
			if [ ${board[i,0]} -eq ${board[i,1]} ] && [ ${board[i,0]} -eq ${board[i,2]} ] # [0,0],[0,1],[0,2]  [1,0],[1,1],[1,2]  [2,0],[2,1],[2,2]
			then
				echo $( declareWinner ${board[i,1]} )
				break
			fi

			if [ ${board[0,i]} -eq ${board[1,i]} ] && [ ${board[0,i]} -eq ${board[2,i]} ] # [0,0],[1,0],[2,0]  [0,1],[1,1],[2,1]  [0,2],[1,2],[2,2]
			then
				echo $( declareWinner ${board[0,i]} )
				break
			fi
		done
	fi

	if [ $winner -eq $NO_WINNER ]
	then
		for (( i=1; i<$BOARD_SIZE; i++ )) # [0,0],[1,1],[2,2]
		do
			if [ ${board[0,0]} -eq ${board[$i,$i]} ]
			then
				continue
			else
				break
			fi
			if [ $(($i+1)) -eq $BOARD_SIZE ]
			then
				echo $( declareWinner ${board[0,0]} )
			fi
		done
	fi

	if [ $winner -eq $NO_WINNER ]
	then
		for (( i=1; i<$BOARD_SIZE; i++ )) # [0,2],[1,1],[2,0]
		do
			if [ ${board[0,2]} -eq  ${board[$i,$(($i%2))]} ]
			then
				continue
			else
				break
			fi
			if [ $(($i+1)) -eq $BOARD_SIZE ]
			then
				echo $( declareWinner ${board[0,2]} )
			fi
		done
	fi	
}

function declareWinner() {
	if [ $1 -eq $PLAYER ]
	then
		echo player
	else
		echo computer
	fi
}

function playerMove() {
	read -p "Enter where you want to play your move : " pos
	if [ $(($pos%$BOARD_SIZE)) -eq 0 ]
	then
		col=$(($BOARD_SIZE-1))
	else
		col=$(($pos%$BOARD_SIZE))
	fi

	row=$((($pos-1)/$BOARD_SIZE))

	if [ ${board[$row.$column]} = "." ]
	then
		board[$row.$column]=$PLAYER
		((chance++))
		else
		echo "worng move, please play a valid move and enter a free block position."
		playerMove
	fi
}


# ************** main program *****************

#start the game

resetBoard

tossResult=$( toss )
count=1
for (( i=0; i<$BOARD_SIZE; i++ ))
do
	for (( j=0; j<$BOARD_SIZE; j++ ))
	do
		printf "| $count "
		((count++))
	done
		printf "|\n-------------\n"
done

while [ $chance -le $(($BOARD_SIZE*$BOARD_SIZE)) ]
do
	
	displayBoard

	"$tossResult"Move

	winner=$( checkWin ${board[@]} )

	if [ $winner -eq $NO_WINNER ]
	then
		continue
	else
		 break
	fi
done
