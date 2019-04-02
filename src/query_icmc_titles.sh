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

Q1=$q
QFILE=${Q1}_results.html
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
	curl -o "$QFILE" "$QUERY"
fi

CNT=0
for i in `cat "$QFILE" | grep -n "table" | cut -f 1 -d:`; do
	TBOUND[$CNT]=$i
	((CNT++))
done
NUM=${TBOUND[1]}
((NUM++))
TBOUND[2]=$NUM

sed -n "${TBOUND[0]},${TBOUND[1]}p;${TBOUND[2]}q" "$QFILE" > "${Q1}_table.html"

sed -n 's/.*href="\([^"]*\).*/\1/p' "${Q1}_table.html" | 
sed '/title$/d' > "${Q1}_links"

open "${Q1}_table.html"

exit
