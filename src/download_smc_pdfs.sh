#!/bin/bash
if [[ $1 ]]
then
	id=$1
	if [[ $2 ]]
	then
		authors="$2"
	else
		"Must provide authors in arg2"
		exit
	fi
else
	"Must provide id in arg1"
	exit
fi

base="https://zenodo.org/record/"

function getfilename()
{
	curl "${base}/${id}" | 
	grep "smc" | 
	grep "<a class=\"filename\"" | 
	cut -f2 -d">" | 
	cut -f1 -d"<"
}

function getbibentry()
{
	curl "${base}/${id}/export/hx" |
	sed -n "/>@/,/<\/pre>/p" |
	cut -f2 -d">" | 
	cut -f1 -d"<"
}

# geturl 849321

if [[ ! -d ./downloads ]]
then
	mkdir ./downloads
fi

filename=`getfilename`
downloadurl="${base}/${id}/files/${filename}?download=1"
if [[ ! -e ./downloads/$filename ]]
then
	echo "Downloading:" "$filename" "..."
	curl -o "./downloads/$filename" "$downloadurl"
else
	echo "$filename" "already exists"
fi

bibentry=`getbibentry`
bibfile="./downloads/smc_main.bib"

if [[ ! -e $bibfile ]]
then
	echo "${bibentry}," > $bibfile
else
	printf "\n%s\n" "${bibentry}," >> $bibfile
fi
# zenodo does not provide authors field!
printf "%s\t%s%s\n}" "  author      " "= " "{$authors}" >> $bibfile
exit