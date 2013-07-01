#!/bin/bash

#
# OpenEmu utility to move core support folders into "~/Library/Application Support/OpenEmu/Core Support/"
# Author: Wolflink289
#










# Function: ansi_color
# Alias: color
# Set the text color.
#
ansi_color() {
	printf "\033["$1"m"
}
alias color=ansi_color

# Function: func_error
# Alias: error
# Display an error message and exit.
#
func_error() {
	color "1;31"
    printf "Error: "
    color "0;31"
    printf "$1\n\n"
    color "0"
    exit
}
alias error=func_error

# Function: arr_contains
# Source: http://stackoverflow.com/questions/3685970/bash-check-if-an-array-contains-a-value
# Checks to see if an array contains a string.
#
arr_contains () {
    local e

    for e in "${@:2}"; do
        e=${e/"%20"/" "}
        if [[ "$e" == "$1" ]]; then
            return 0
        fi
    done

    return 1
}

#
#
# MAIN
#
#
oedir="$HOME/Library/Application Support/OpenEmu"
oefiles=("Bindings%20Configurations" "Core%20Support" "Cores" "Game%20Library" "Save%20States" "Screenshots")
changed=0

# Check for OpenEmu folder.
if [ -d "$oedir/" ]; then

    # Check for Core Support folder.
    color "0;36"
    printf "Checking for \"Core Support\"... "
    if [ -d "$oedir/Core Support/" ]; then
        if [ -f "$oedir/Core Support/" ]; then
            color "0;31"
            printf "?\n"
            error "\"~/Library/Application Support/OpenEmu/Core Support\" is a file, when it should be a directory."
        else
            color "0"
            printf "Found!\n"
        fi
    else
        color "0"
        mkdir "$oedir/Core Support/"
        printf "Created!\n"
    fi
    
    # Search OpenEmu folder.
    color "0;36"
    printf "Scanning for core support folders...\n"
    for fpath in "$oedir"/* ; do
        
        spath=${fpath##*/}
        if arr_contains "$spath" ${oefiles[@]} ; then
            continue
        fi

        # Move to core support.
        changed=$((changed + 1))
        color "0;36"
        printf "Found: "
        color "0"
        echo "$spath"
        mv "$fpath" "$oedir/Core Support/$spath/"

    done

    # Done
    if [ $changed -gt 0 ]; then
        color "0;36"
        printf "$changed core support folders were moved!\n"
    else
        color "0;36"
        printf "No core support folders were found!\n"
    fi

else
    error "Cannot find OpenEmu directory!"
fi

printf "\n"
color "0"