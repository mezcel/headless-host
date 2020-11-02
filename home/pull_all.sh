#!/bin/bash
#
# pull_all.sh
# Instructions: 
#	./pull_all.sh <directory path>
#

function repoLibrary {
	inputDir=$1
	if [ ! -z $inputDir ]; then
		## Check input path
		if [ -d $inputDir ]; then
			echo "input string: $inputDir"
			cd $inputDir
		else
			echo "## $inputDir is not a directory."
			exit
		fi
	fi
}

function directoryForLoop {
	for directoryName in *
	do
		if [ -d $directoryName ]; then
			echo -e "\n##\n## Working on Dir $directoryName ...\n## "
			cd "$directoryName"
			git pull
			cd ../
		else
			echo "## Not a dir: $directoryName"
		fi
	done
}

function main {
	inputDir=$1
	echo -e "\n###\n### Automatically git pull to update all github repos in directory\n###\n"

	## main
	repoLibrary $inputDir
	directoryForLoop

	echo "Done"
}

main $1