#!/system/bin/env bash

light() {
	echo -ne "\033[92m"
}

dark() {
	echo -ne "\033[32m"
}

yellow() {
	echo -ne "\033[33m"
}

blue() {
	echo -ne "\033[34m"
}

green() {
    dark
}

red() {
	echo -ne "\033[31m"
}

clr() {
	echo -ne "\033[0m"
}

bg() {
	dark
}

dark

xs=$((RANDOM % 4))

if [ $xs == 0 ]; then 
	echo -e "`bg`  ____________________   `clr`"
	echo -e "`bg` /                    \\  `clr`"
	echo -e "`bg` |  YOU DRIVE A HARD  |  `clr`"
	echo -e "`bg` |       BURGER!      |  `clr`"
	echo -e "`bg` \____   _____________/  `clr`"
	echo -e "`bg`      \\ |                `clr`"
	echo -e "`bg`       \\|                `clr`"
elif [ $xs == 1 ]; then
	echo -e "`bg`  _____________________  `clr`"
	echo -e "`bg` /                     \\ `clr`"
	echo -e "`bg` | USE THE COMBO MOVE! | `clr`"
	echo -e "`bg` \____   ______________/ `clr`"
	echo -e "`bg`      \\ |                `clr`"
	echo -e "`bg`       \\|                `clr`"
elif [ $xs == 2 ]; then
	echo -e "`bg`  ____________________   `clr`"
	echo -e "`bg` /                    \\  `clr`"
	echo -e "`bg` |       RED-HOT      |  `clr`"
	echo -e "`bg` |  LIKE PIZZA SUPPER |  `clr`"
	echo -e "`bg` \____   _____________/  `clr`"
	echo -e "`bg`      \\ |                `clr`"
	echo -e "`bg`       \\|                `clr`"
else
	echo -e "`bg`  ____________________   `clr`"
	echo -e "`bg` /                    \\  `clr`"
	echo -e "`bg` |    CHECK PLEASE!   |  `clr`"
	echo -e "`bg` \____   _____________/  `clr`"
	echo -e "`bg`      \\ |                `clr`"
	echo -e "`bg`       \\|                `clr`"
fi

echo -e "`bg`     ._________          `clr`" 
echo -e "`bg`    /_________/|         `clr`" 
echo -e "`bg`    |`light`.-------.`dark`||         `clr`" 
echo -e "`bg`    |`light`|o   o  |`dark`||         `clr`" 
echo -e "`bg`    |`light`|  -    |`dark`||         `clr`" 
echo -e "`bg`    |`light`'-------'`dark`||         `clr`" 
echo -e "`bg`    | ___  .  ||         `clr`" 
echo -e "`bg`   /|         |\\         `clr`" 
echo -e "`bg`  / | `yellow`+   `blue`^`dark` `green`o`dark` ||\\        `clr`" 
echo -e "`bg`    | --   `red`O`dark`  ||         `clr`" 
echo -e "`bg`    '---------/          `clr`" 
echo -e "`bg`      I     I            `clr`" 
clr
