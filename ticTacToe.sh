#!/bin/bash

# constants
BOARD_SIZE=3
PLAYER="O"
COMPUTER="X"
COUNT=1
PLAYER_FIRST_MOVE=1  # so COMPUTER_FIRST_MOVE will be 0
NO_WINNER="N"
EMPTY_BLOCK="."
COUNTER=1
# variables
winner="N"
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
	for (( i=0; i<$BOARD_SIZE; i++ ))
	do
		for (( j=0; j<$BOARD_SIZE; j++ ))
		do
			board[$i,$j]="."
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


# function to declare the winner
function declareWinner() {
	if [ $1 = $PLAYER ]
	then
		echo player
	else
		echo computer
	fi
}

# function to check win , tie or next move
# 1 2 3
# 4 5 6
# 7 8 9
function checkWin() {
	if [ $winner = $NO_WINNER ]
	then
		for (( i=0; i<$BOARD_SIZE; i++ ))
		do
			if [ ${board[$i,0]} = ${board[$i,1]} ] && [ ${board[$i,0]} = ${board[$i,2]} ] && [ ${board[$i,0]} != $EMPTY_BLOCK ] && [ ${board[$i,1]} != $EMPTY_BLOCK ] && [ ${board[$i,2]} != $EMPTY_BLOCK ] # [0,0],[0,1],[0,2]  [1,0],[1,1],[1,2]  [2,0],[2,1],[2,2]
			then
				winner=$( declareWinner ${board[$i,1]} )
				break
			fi

			if [ ${board[0,$i]} = ${board[1,$i]} ] && [ ${board[0,$i]} = ${board[2,$i]} ] && [ ${board[0,$i]} != $EMPTY_BLOCK ] && [ ${board[1,$i]} != $EMPTY_BLOCK ] && [ ${board[2,$i]} != $EMPTY_BLOCK ] # [0,0],[1,0],[2,0]  [0,1],[1,1],[2,1]  [0,2],[1,2],[2,2]
			then
				winner=$( declareWinner ${board[0,$i]} )
				break
			fi
		done
	fi

	if [ $winner = $NO_WINNER ]
	then
		if [ ${board[0,0]} = ${board[1,1]} ] && [ ${board[0,0]} = ${board[2,2]} ] && [ ${board[0,0]} != $EMPTY_BLOCK ] # [0,0],[1,1],[2,2]
		then
			echo right to left corner
			winner=$( declareWinner ${board[0,0]} )
		fi
	fi

	if [ $winner = $NO_WINNER ]
	then
		if [ ${board[0,2]} = ${board[1,1]} ] && [ ${board[0,2]} = ${board[2,0]} ] && [ ${board[0,2]} != $EMPTY_BLOCK ]
		then
			echo left to right cornwe
			winner=$( declareWinner ${board[0,2]} )
		fi
	fi	
}

# function to check winning move
function checkWinningMove() {
	counter=1
	for (( row=0; row<$BOARD_SIZE; row++ ))
	do
		for (( column=0; column<$BOARD_SIZE; column++ ))
		do
			if [ ${board[$row,$column]} = $EMPTY_BLOCK ]
			then
				board[$row,$column]=$1
				checkWin
				if [ $winner = "computer" ]
				then
					echo $winner wins the game !!!!
					exit
				elif [ $winner = "player" ]
				then
					board[$row,$column]=$COMPUTER
					((chance++))
					counter=0
					winner=$NO_WINNER
					break
				elif [ $winner = $NO_WINNER ]
				then 
					board[$row,$column]=$EMPTY_BLOCK
				fi
			fi
		done
	if [ $counter -eq 0 ] 
	then
		break
	fi
	done
}


function playerMove() {
	read -p "Enter where you want to play your move : " pos
	if [ $(($pos%$BOARD_SIZE)) -eq 0 ]
	then
		col=$(($BOARD_SIZE-1))
	else
		col=$(($pos%$BOARD_SIZE-1))
	fi

	row=$((($pos-1)/$BOARD_SIZE))
	echo $row,$col
	if [ ${board[$row,$col]} = $EMPTY_BLOCK ]
	then
		board[$row,$col]=$PLAYER
		((chance++))
		else
		echo "worng move, please play a valid move and enter a free block position."
		playerMove
	fi
}

function computerMove() {
	printf "\nComputer chance !!!\n"
	pos=$((RANDOM%9+1))
	if [ $(($pos%$BOARD_SIZE)) -eq 0 ]
	then
		col=$(($BOARD_SIZE-1))
	else
		col=$(($pos%$BOARD_SIZE-1))
	fi

	row=$((($pos-1)/$BOARD_SIZE))

	if [ ${board[$row,$col]} = "." ]
	then
		board[$row,$col]=$COMPUTER
		((chance++))
		else
		echo "worng move, please play a valid move and enter a free block position."
		computerMove
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

	if [ $tossResult = "player" ]
	then
		"$tossResult"Move
		tossResult="computer"
		checkWin
	else
		checkWinningMove $COMPUTER
		checkWinningMove $PLAYER
		if [ $counter -eq $COUNTER ]
		then
			"$tossResult"Move
			tossResult="player"
		fi
	fi

	if [ $winner = $NO_WINNER ]
	then
		continue
	else
		echo $winner wins the game
		 break
	fi
done

if [ $winner = $NO_WINNER ] 
then
	echo draw
fi
