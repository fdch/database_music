#!/bin/bash
ROOT=~/Documents/fd_work/text/waves/bin
#	LOAD VARIABLES (FIRST AND IN THIS ORDER)
for i in metadata paths settings pandoc usage structure_array
do
	source $ROOT/metadata/${i}.sh
done

#	LOAD ROUTINES
source $SRCDIR/routines.sh
WEBNOTE="NOTE: The website version (html) does not display correctly: acronyms; glossary entries; some inline references (which might look weird); and the transcribed text score. Please, open/download the .pdf to see how these things actually look like :)"
#	ARGUMENT CHECK
function _main_()
{
	local a=$1
	if   [[ !  $a   ]]
	then 
		main
	elif [[ $a == "-b" ]] || [[ $a == "--biblio"  ]] || [[ $1 == 0 ]]
	then 
		make_bib
	elif [[ $a == "-m" ]] || [[ $a == "--concat"  ]] || [[ $1 == 1 ]]
	then
		make_latex
	elif [[ $a == "-l" ]] || [[ $a == "--compile" ]] || [[ $1 == 2 ]]
	then 
		compile_latex
	elif [[ $a == "-c" ]] || [[ $a == "--count"   ]] || [[ $1 == 3 ]]
	then
		count_words
	elif [[ $a == "-p" ]] || [[ $a == "--pandoc"  ]] || [[ $1 == 4 ]]
	then 
		make_html
		make_docx
	elif [[ $a == "-t" ]] || [[ $a == "--tidy"    ]] || [[ $1 == 5 ]]
	then
		tidy_up
	elif [[ $a == "-k" ]] || [[ $a == "--backup" 	  ]] || [[ $1 == 6 ]]
	then
		sh backup
	elif [[ $a == "-d" ]] || [[ $a == "--delete"  ]] || [[ $1 == 7 ]]
	then
		delete_temp
	elif [[ $a == "-f" ]] || [[ $a == "--fresh"   ]] || [[ $1 == 8 ]]
	then
		sh getstruct
		source "metadata/structure_array.sh"
		main
	elif [[ $a == "-r" ]] || [[ $a == "--reset"   ]] || [[ $1 == 9 ]]
	then
		sh getgloss
		sh getstruct
		source "metadata/structure_array.sh"
		main
	elif [[ $a == "-h" ]] || [[ $a == "--help"   ]] || [[ $1 == 10 ]]
	then
		help_message
	elif [[ $a == "-g" ]] || [[ $a == "--compare" ]] || [[ $1 == 11 ]]
	then
		compare $2 $3
	elif [[ $a == "-e" ]] || [[ $a == "--preview" ]] || [[ $1 == 12 ]]
	then
		if [[ ! -f ${NAME}.bib ]]
		then
			make_bib
		fi
		make_latex
		if [[ ! -f ${NAME}.aux ]]
		then
			compile_latex
		fi
		pdflatex $LATEXFLAGS ${NAME}.tex
		open ${NAME}.pdf
	elif [[ $a == "--paper" ]]
	then
		make_bib "${PNAME}" "${PAPERBIB}"
		make_paper
		compile_paper
		tidy_up "${PNAME}"
		open "output/${PNAME}.pdf"
	else
		wrong_args
	fi
	if [[ $TOTALWORDS != "0" ]] && [[ $NEWWORDS != "N" ]]
	then
		print_comment "Total: $TOTALWORDS | New: $NEWWORDS | `date`"
	fi
}
_main_ "$@"
exit