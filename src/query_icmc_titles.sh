#!/bin/bash
#	get ICMC search results into html table
if [[ $1 ]] ; then
	q="$1"
else
	echo "Provide one-word query, eg: 'data'"
	exit 1
fi
if [[ $2 ]] ; then
	REGION="$2"
else
	echo "['title','author','abstract','full+text']"
	echo "Default: 'title'"
	REGION='title'
fi
QFILE=${Q1}_results.html
Q1=$q
SIZE=1000
TYPE=simple
BASEURL=https://quod.lib.umich.edu/i/icmc
QUERY="\
${BASEURL}?\
type=${TYPE}&\
q1=${Q1}&\
rgn=${REGION}&\
size=${SIZE}&\
Submit=Search\
"
if [[ -f "$QFILE" ]] ; then
	echo "File Exists. Skip download"
else
	source parse_icmc_results.sh
	curl -o "$QFILE" "$QUERY"
	parse_results "$QFILE"
fi

exit