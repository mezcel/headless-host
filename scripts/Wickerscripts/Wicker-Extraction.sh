#!/bin/bash

## Put this in the same directory that contains wickerscript's pkgdownload

function decorativeColors() {

	## Foreground Color using ANSI escape

	FG_BLACK=$(tput setaf 0)
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)
	FG_WHITE=$(tput setaf 7)
	FG_NoColor=$(tput sgr0)

	## Background Color using ANSI escape

	BG_BLACK=$(tput setab 0)
	BG_RED=$(tput setab 1)
	BG_GREEN=$(tput setab 2)
	BG_YELLOW=$(tput setab 3)
	BG_BLUE=$(tput setab 4)
	BG_MAGENTA=$(tput setab 5)
	BG_CYAN=$(tput setab 6)
	BG_WHITE=$(tput setab 7)
	BG_NoColor=$(tput sgr0)

	## set mode using ANSI escape

	MODE_BOLD=$(tput bold)
	MODE_DIM=$(tput dim)
	MODE_BEGIN_UNDERLINE=$(tput smul)
	MODE_EXIT_UNDERLINE=$(tput rmul)
	MODE_REVERSE=$(tput rev)
	MODE_ENTER_STANDOUT=$(tput smso)
	MODE_EXIT_STANDOUT=$(tput rmso)

	# clear styles using ANSI escape

	STYLES_OFF=$(tput sgr0)
}

function extract_wickerscripts {

	extracted_dir_dir=ExtractedWickerscriptZips

	echo -e "$FG_YELLOW \nExtracting $(pwd)/*.tar.gz\n\tinto the $(pwd)/$extracted_dir_dir directory \n $FG_MAGENTA"

	mkdir -p $extracted_dir_dir
	sleep 2s

	find . -name '*.tar.gz' -execdir tar -xzvf '{}' -C $extracted_dir_dir \;

	echo -e "$FG_GREEN\nDone.\n $STYLES_OFF"

}

function consolidated_debs {

	consolidated_deb_dir=downloaded-debs

	echo -e "$FG_YELLOW \nConsolidating *.deb packages from $(pwd)/$extracted_dir_dir\n\t\tinto the $(pwd)/$consolidated_deb_dir/ \n"

	mkdir -p $consolidated_deb_dir
	sleep 2s

	## Move debs to a common dir
	for f in $extracted_dir_dir/*; do
		if [ -d "$f" ]; then
			echo -e "$FG_CYAN\tMoving $f/*.deb\n\t\tinto $(pwd)/$consolidated_deb_dir/"

			# $f is a directory
			mv -n $f/*.deb $consolidated_deb_dir/
			sleep 2s

			#noOfDebs=$(find $consolidated_deb_dir/ -type f -iname "*.deb" | wc -l)
			#if [ $noOfDebs -eq 0 ]; then
			#	rm -rf $f
			#fi

			echo -e "${FG_GREEN}\tDone.\n"
		fi
	done

	sleep 2

	echo "$STYLES_OFF"

}

function make_refference_lists {

	## Del old extraction dirs
    rm -rf $extracted_dir_dir

    cp index_downloaded_debs.sh $consolidated_deb_dir/

    ls *.tar.gz > 000-TotalGzList.txt
    ls $consolidated_deb_dir | grep ".deb" > 000-TotalDebList.txt
}

#####################
## Run
#####################

decorativeColors

extract_wickerscripts

consolidated_debs && make_refference_lists