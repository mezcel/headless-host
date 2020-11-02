#!/bin/bash

## this script is used to help my muscle memmory for the keyboard
## Keyboards come in many sizes and shapes, and some keyboards are ergonomic.
## This is just a script to get my fingers used to moveing correctly where ever the letter keys are on the keyboard.


function tput_color_variables {
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)

	FG_BOLD=$(tput bold)
	FG_START_UNDERLINE=$(tput smul)
	FG_END_UNDERLINE=$(tput rmul)

	## tur off attributes
	BG_NoColor=$(tput sgr0)
	FG_NoColor=$(tput sgr0)

	## you may need a special font to read the X or check marks
	## not sure what the dependency is for this
	CHECKMARK='\u2714'
	XMARK='\u274c'
}

function greetings {
	echo -e "${FG_CYAN}This is a keyboard finger trainer. It only focuses on letter keys.\
	\n\tA better version of this program is at: https://github.com/mezcel/keyboard-layout.git \n${FG_NoColor}"
}

function letter_array {
	letterArray=(a b c d e f g h i j k l m n o p q r s t u v w x y z , . \; \/) ## 0 - 29
	wordsArray=("acre" "art" "avert" "badge" "based" "braces" "case" "crabs" "craft" "date" "draw" "dwarf" "exact" "fact" "few" "gate" "gears" "grave" "raft" "read" "rest" "sweat" "saved" "staged" "taxes" "tear" "trade" "vast" "verbs" "vase" "wafer" "wage" "water" "zebra" "him" "hump" "hymn" "ink" "ion" "imply" "join" "jump" "july" "kin" "kiln" "limp" "lumpy" "loop" "monk" "milk" "my" "no" "ohm" "nymph" "oh" "opium" "only" "pink" "punk" "pony" "uplink" "unholy" "up" "you" "yuk" "yum") ## 0 - 64

	leftArray=(q w e r t a s d f g z x c v b) ## 0 - 14
	leftPinky=(q a z)		## 0 - 2
	leftRing=(w s x)		## 0 - 2
	leftMiddle=(e d c)		## 0 - 2
	leftIndex=(r t f g v b)	## 0 - 5
	leftWords=("acre" "art" "avert" "badge" "based" "braces" "case" "crabs" "craft" "date" "draw" "dwarf" "exact" "fact" "few" "gate" "gears" "grave" "raft" "read" "rest" "sweat" "saved" "staged" "taxes" "tear" "trade" "vast" "verbs" "vase" "wafer" "wage" "water" "zebra") ## 0 - 33

	rightArray=(y u o p h j k l n m , .) ## 0 - 11
	rightIndex=(y u h j n m )	## 0 - 5
	rightMiddle=(i k ,)			## 0 - 2
	rightRing=(o l .)			## 0 - 2
	rightPinky=(p \; \/)		## 0 - 2
	rightWords=("him" "hump" "hymn" "ink" "ion" "imply" "join" "jump" "july" "kin" "kiln" "limp" "lumpy" "loop" "monk" "milk" "my" "no" "ohm" "nymph" "oh" "opium" "only" "pink" "punk" "pony" "uplink" "unholy" "up" "you" "yuk" "yum") ## 0 - 31
}

function define_digit {

	echo -e "Which finger do you want to focus on:\n\t1. left pinky\n\t2. left ring\n\t3. left middle\n\t4. left index\n\n\t7. right index\n\t8. right middle\n\t9. right ring\n\t0. right pinky\n\n\t5. or 6. all\n"
	read -p "Which finger? [ 0 - 9 ]: " digit

	case $digit in
		1 )
			ARRAY=("${leftPinky[@]}")
			CEILING=2
			;;
		2 )
			ARRAY=("${leftRing[@]}")
			CEILING=2
			;;
		3 )
			ARRAY=("${leftMiddle[@]}")
			CEILING=2
			;;
		4 )
			ARRAY=("${leftIndex[@]}")
			CEILING=5
			;;
		7 )
			ARRAY=("${rightIndex[@]}")
			CEILING=5
			;;
		8 )
			ARRAY=("${rightMiddle[@]}")
			CEILING=2
			;;
		9 )
			ARRAY=("${rightRing[@]}")
			CEILING=2
			;;
		0 )
			ARRAY=("${rightPinky[@]}")
			CEILING=2
			;;
		* )
			ARRAY=("${leftArray[@]}")
			CEILING=14
			;;
	esac
}

function define_hand {
	echo -e "Full hand exercise:\n\t1. left hand letters\n\t2. left hand words\n\t3. right had letters\n\t4. right hand words\n\t5. all letters\n\t6. all words.\n"

	read -p "Select option [ 1 - 6 ]: " hand

	case $hand in
		1 )
			ARRAY=("${leftArray[@]}")
			CEILING=14
			;;
		2 )
			ARRAY=(${leftWords[@]})
			CEILING=33
			;;
		3 )
			ARRAY=("${rightArray[@]}")
			CEILING=11
			;;
		4 )
			ARRAY=(${rightWords[@]})
			CEILING=31
			;;
		5 )
			ARRAY=("${letterArray[@]}")
			CEILING=29
			;;
		6 )
			ARRAY=(${wordsArray[@]})
			CEILING=64
			;;
		* )
			ARRAY=(${wordsArray[@]})
			CEILING=64
			;;
	esac
}

function menu {
	echo -e "Which do you want to focus on:\n\t1. finger\n\t2. hand\n\t3. test string\n"
	read -p "Which option? [1, 2, 3]: " hand

	case $hand in
		1 )
			define_digit
			;;
		2 )
			define_hand
			;;
		3 )
			read -p "enter a string to practice with: " letter
			ARRAY+=($letter)
			CEILING=0
			;;
		* )
			ARRAY=("${letterArray[@]}")
			CEILING=29
			;;
	esac

	echo -e "${FG_GREEN}---\nStart training your fingers\nPress \"Esc\" or Esc+Enter or Ctrl+C to exit\n${FG_NoColor}"
}

function random_letter {
	FLOOR=0
	RANGE=$(($CEILING-$FLOOR+1))
	random_number=$RANDOM
	let "random_number %= $RANGE"
	random_number=$(($random_number+$FLOOR))
	letter=(${ARRAY[$random_number]})
}

function finger_digit {
	#letter=$1

	case $letter in
		[qaz]* )
			finger="${FG_START_UNDERLINE}L${FG_END_UNDERLINE}eft pinky"
			;;
		[p\;\/]* )
			finger="${FG_START_UNDERLINE}R${FG_END_UNDERLINE}ight pinky"
			;;
		[wsx]* )
			finger="${FG_START_UNDERLINE}L${FG_END_UNDERLINE}eft ring"
			;;
		[ol.]* )
			finger="${FG_START_UNDERLINE}R${FG_END_UNDERLINE}ight ring"
			;;
		[edc]* )
			finger="${FG_START_UNDERLINE}L${FG_END_UNDERLINE}eft middle"
			;;
		[ik,]* )
			finger="${FG_START_UNDERLINE}R${FG_END_UNDERLINE}ight middle"
			;;
		[rtfgvb]* )
			finger="${FG_START_UNDERLINE}L${FG_END_UNDERLINE}eft index"
			;;
		[yuhjnm]* )
			finger="${FG_START_UNDERLINE}R${FG_END_UNDERLINE}ight index"
			;;
		* )
			finger="${FG_START_UNDERLINE}R${FG_END_UNDERLINE}ight pinky"
			;;
	esac
}

function finger_check {
	pass=0
	escKey=$'\e'

	while [ $pass -eq 0 ]
	do
		if [ ${#letter} -eq 1 ]; then
			read -p "[ $finger ]  ${FG_CYAN}${FG_BOLD}$letter${FG_NoColor}  ==> " -n1 -s inputPress
		else
			read -p "[${FG_START_UNDERLINE} multi digit ${FG_END_UNDERLINE}]  ${FG_CYAN}${FG_BOLD}$letter${FG_NoColor}  ==> " -n${#letter} inputPress
		fi

		case $inputPress in
			$escKey )
				echo -e "\n\n${FG_GREEN} $CHECKMARK Pass:$passCount ${FG_RED} $XMARK Fail:$failCount ${FG_NoColor}"
				echo -e "\n Quit App"
				exit
				;;

			$letter )
				echo -e "${FG_GREEN} $CHECKMARK  pass ${FG_NoColor}"
				pass=1
				passCount=$((passCount + 1))
				;;

			* )
				echo -e "${FG_RED} $XMARK fail, you entered: ${FG_CYAN}${FG_BOLD}$inputPress ${FG_NoColor}"
				pass=0
				failCount=$((failCount + 1))
				;;
		esac
	done
}

function main {
	tput_color_variables
	greetings
	letter_array

	menu

	run=1
	passCount=0
	failCount=0

	while [ $run -eq 1 ]
	do
		random_letter
		finger_digit
		finger_check
	done
}

main
