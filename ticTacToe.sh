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
CONTINUE_GAME=1
STOP_GAME=0

# variables
winner="N"
chance=1
userChoice=0
game=1

# baord
declare -A board

# fucntion toss for deciding who will start the game
function toss() {
	temp=$((RANDOM%2))
	if [ $temp -eq $PLAYER_FIRST_MOVE ]
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
			board[$i,$j]=$EMPTY_BLOCK
		done
	done
}

# fucntion to display the board
function displayBoard() {
	printf "Board\n"
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

# function to check winner  MAIN LOGIC
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

		if [ ${board[0,0]} = ${board[1,1]} ] && [ ${board[0,0]} = ${board[2,2]} ] && [ ${board[0,0]} != $EMPTY_BLOCK ] # [0,0],[1,1],[2,2]
		then
			winner=$( declareWinner ${board[0,0]} )
		fi

		if [ ${board[0,2]} = ${board[1,1]} ] && [ ${board[0,2]} = ${board[2,0]} ] && [ ${board[0,2]} != $EMPTY_BLOCK ]
		then
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
					displayBoard
					echo $winner wins the game !!!!
					game=$STOP_GAME
					counter=0
					break
				elif [ $winner = "player" ]
				then
					board[$row,$column]=$COMPUTER
					((chance++))
					counter=0
					winner=$NO_WINNER
					displayBoard
					tossResult="player"
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

function assignPriorityPosition(){
	if [ $counter -eq $COUNTER ]
	then
		if [ ${board[$2,$3]} == "." ]
		then
			board[$2,$3]=$1
			((chance++))
			counter=0
		fi
	fi
}


# fucntion for computer move
function computerPriorityMove() {

	#Take corners if avalible
	for (( row=0; row<$BOARD_SIZE; $((row+=2)) ))
	do
		for (( column=0; column<$BOARD_SIZE; $((column+=2)) ))
		do
			if [ $counter -eq $COUNTER ]
			then
				assignPriorityPosition $1 $row $column
			fi
		done
	done

	#Take Centre if availible
	if [ $counter -eq $COUNTER ]
	then
		assignPriorityPosition $1 $(($BOARD_SIZE/2)) $(($BOARD_SIZE/2))
	fi

	# finally Take sides left
	for (( row=0; row<$BOARD_SIZE;row++ ))
	do
		for (( column=0; column<$BOARD_SIZE; column++ ))
		do
			assignPriorityPosition $1 $row $column
		done
	done
}


# fucntion for player move
function playerMove() {
	read -p "Enter position where you want to play your move form 1 to 9 : " pos
	if [ $pos -ge 1 ] && [ $pos -le 9 ]
	then
		if [ $(($pos%$BOARD_SIZE)) -eq 0 ]
		then
			col=$(($BOARD_SIZE-1))
		else
			col=$(($pos%$BOARD_SIZE-1))
		fi

		row=$((($pos-1)/$BOARD_SIZE))
		if [ ${board[$row,$col]} = $EMPTY_BLOCK ]
		then
			board[$row,$col]=$PLAYER
			((chance++))
			else
			echo "worng move, please play a valid move and enter a free block position."
			playerMove
		fi
	else
		echo "Enter valid position please"
		playerMove
	fi
}


# ************** main program *****************

#start the game

while [ $game -eq $CONTINUE_GAME ]
do 
	resetBoard # resetting the baord at game start

	tossResult=$( toss ) # doing the toss
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

	 # playin the game till a block is empty on board or someone wins
	while [ $chance -le $(($BOARD_SIZE*$BOARD_SIZE)) ]
	do

		if [ $tossResult = "player" ]
		then
			"$tossResult"Move # player move
			displayBoard # displayin the board
			tossResult="computer"
			checkWin # checking if anyone winning
		else
			printf "\nComputer chance !!!\n"
			checkWinningMove $COMPUTER # computer searching for a move where it can win
			if [ $game -eq $CONTINUE_GAME ]
			then
				checkWinningMove $PLAYER # computer looking if player wins in next move, if yes then block
				if [ $counter -eq $COUNTER ]
				then
					"$tossResult"PriorityMove $COMPUTER # computer move
					displayBoard # displayin board
					tossResult="player"
				fi
			else
				break
			fi
		fi

		if [ $winner = $NO_WINNER ]
		then
			continue
		else
			displayBoard
			echo $winner wins the game
			break
		fi	

	done

	# if no winner till now the game is a draw
	if [ $winner = $NO_WINNER ] 
	then
		echo draw
	fi

	# At the game end asking the user if he wants to play again or exit the game
	echo "Do you want to play again ?"
	echo "Press 1 to play again"
	echo "Press any other key to stop playin and get out"
	read userChoice

	case $userChoice in
		1)
			game=$CONTINUE_GAME
			counter=1
			chance=1
			winner=$NO_WINNER
			;;
		*)
			echo "Thanks for playin. Hope you enjoyed !!!"
			game=$STOP_GAME
	esac
done
