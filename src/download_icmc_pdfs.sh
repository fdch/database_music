#!/bin/bash

BASE="https://quod.lib.umich.edu/cgi/p/pod/dod-idx/"
FORMAT=";format=pdf"
COUNT=0

if [[ $1 ]]; then
	mkdir downloads
	while read line ; do
		varid=`echo "$line" | cut -f 6 -d/`
		nam=`echo "$line" | cut -f 8 -d/`
		name=`echo "$nam" | cut -f 1 -d?`
		varname=`echo "$name" | sed 's/--//'`

		#	E.G.: mobile-phones-as-ubiquitous-instruments-towards
		NAME="$varname.pdf?c=icmc;idno="

		ID=$varid # E.G.: bbp2372.2014.080

		PDFLINK="$BASE$NAME$ID$FORMAT"

		YEAR=`echo $ID | cut -f 2 -d. | cut -f 1 -d.`

		wget -O "downloads/$YEAR-icmc-$varname.pdf" "$PDFLINK"
		# echo " curl -O $YEAR-icmc-$varname.pdf $PDFLINK"
		((COUNT++))
	done < $1
else
	echo "Provide an argument to a file (list of icmc-formated-hyperlinks copied from https://quod.lib.umich.edu/i/icmc and its search results table)"
	echo "No files dowloaded. Exiting."
	exit 1
fi

echo "$COUNT files downloaded. Exiting."
exit