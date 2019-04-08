#!/bin/bash

function parse_results()
{	
	local QFILE=''
	local QDEST=''
	local QLINK=''
	local CNT=0
	local NUM=0
	
	if [[ $1 ]]
	then
		QFILE=$1
		QDEST="${QFILE}_table.html"
		QLINK="${QFILE}_links.html"
	else
		echo "parse_results(): No file input..."
		return 1
	fi

	for i in `cat "$QFILE" | grep -n "table" | cut -f 1 -d:`; do
		TBOUND[$CNT]=$i
		((CNT++))
	done

	NUM=${TBOUND[1]}
	((NUM++))
	TBOUND[2]=$NUM

	sed -n "${TBOUND[0]},${TBOUND[1]}p;${TBOUND[2]}q" $QFILE > $QDEST

	sed -n 's/.*href="\([^"]*\).*/\1/p' $QDEST | 
	sed '/title$/d' > $QLINK

	open $QDEST
}


if [[ $1 ]]
then
	parse_results $1
fi






