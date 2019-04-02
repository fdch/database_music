#!/bin/bash
#==============================================================================
#	PARSE ARGS FOR HELP MESSAGE
#==============================================================================

NOCONVERT=0
COMPILEONLY=0

while getopts "h?vnto:" opt; do
    case "$opt" in
    h|\?)
       	VERBOSE=1; msg "$WELCOME$USAGE"; exit 0
        ;;
    v)
		VERBOSE=1
		;;
    n)
		VERBOSE=1; NOCONVERT=1
		;;
	t)
		VERBOSE=1; COMPILEONLY=1
		;;
    o)
        EXT=$OPTARG
        ;;
    esac
done