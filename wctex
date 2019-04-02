#!/bin/bash
function getword()
{
	cat $1 > /tmp/wct
	echo `texcount -sum -inc -brief /tmp/wct 	|
				cut -d : -f 1 					|
				sed '/[^0-9]/d' 				|
				tail -n 1`
}
c=0
for i in "$@"
do
	wc=0
	if [ -d $i ]
	then
		files=$i/*.tex
		for f in ${files[@]}
		do
			((wc=wc+`getword $f`))
		done
	else
		wc=`getword $i`
	fi
	((c=$c+$wc))
done
echo $c
