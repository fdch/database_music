#!/bin/bash

function make_line()
{
	#	MAKE A LINE FITTING TERMINAL WIDTH
	local col=`tput cols`
	local i=0
	if [[ $col -eq 0 ]]
	then
		col=80
	fi
	while [ $i -lt $col ]
	do
		LINE+=-
		i=$[$i+1]
	done
}

#	MAKE THE LINE ONCE SO WE CAN USE IT
make_line

function print_comment()
{
	#	PRINT FLASHIER COMMENTS TO CONSOLE
	echo "${@}"
	echo "$(tput setaf 2)${LINE}$(tput sgr 0)"
}

function write_comment()
{
	#	RETURN LATEX COMMENT

	printf '\n%%%78s\n%%\n' | tr ' ' -
	printf '%%\t%s\n' "$1"
	if [[ $2 -eq 1 ]]; then printf '%%\t%s\n' "$WARNING"; fi
	printf '%%\n%%%78s\n' | tr ' ' -
}

function make_bib()
{
	#	MAKE ONE HUGE BIBLIOGRAPHY FILE WITH ALL ENTRIES
	#	...REPLACING THE PREVIOUS ONE...
	local bib_file=${MAINBIB}
	local bib_name=${NAME}
	if [[ $1 ]] && [[ $2 ]]
	then
		bib_name=$1
		bib_file=$2
	fi

	echo > $bib_file

	print_comment "make_bib(): Making '$bib_file' named '$bib_name'"
	write_comment "BEGIN: Bibliography"	1			>>	$bib_file

	for i in ${BIBPATH}/*
	do 
		write_comment "BEGIN: $i"	1				>>	$bib_file
		cat $i 										>>	$bib_file 
		write_comment "END: $i"						>>	$bib_file

	done
	pandoc-citeproc -j $bib_file > $BIBTIME/${bib_name}.json
}

function make_preamble()
{
	local name 	#	for packages
	local cont
	local n 	#	for new commands
	local a
	local c
	write_comment "BEGIN: Preamble" 
	printf "%s\n" "\documentclass[$classparams]{$class}"
	#
	#	PACKAGES
	#
	for ((i = 0; i < ${#packages[@]}; i+=2))
	do
		name="${packages[$i]}"
		cont="${packages[$((i+1))]}"
		if [[ ! "$cont" ]]
		then
			printf  "%s\n" "\usepackage{$name}"
		else
			printf	"%s\n" "\usepackage[$cont]{$name}" 
		fi
	done
	#
	#	NEWCOMMANDS
	#
	write_comment "Custom commands"
	for ((i = 0; i < ${#newcommands[@]}; i+=3))
	do
		n="${newcommands[$i]}"
		a="${newcommands[$((i+1))]}"
		c="${newcommands[$((i+2))]}"
		printf "%s\n" "\newcommand{\\$n}[$a]{$c}"
	done
	
	printf "%s\n" "$extrasettings"

	#
	#	GLOSSARY
	#
	write_comment "GLOSSARY & ACCRONYM ENTRY:\
	https://en.wikibooks.org/wiki/LaTeX/Glossary"
	# printf "%s\n" "\makeglossaries"
	printf "%s\n" "\import{$GLOSSARY}{definitions.tex}"
	#
	#	BIBLIOGRAPHY
	#
	write_comment "Bibliography (bitlatex-biber)"
	if [[ $1 ]]
	then
		printf "%s\n" "\addbibresource{$1}"
	else
		printf "%s\n" "\addbibresource{$MAINBIB}"
	fi
	write_comment "APA style with ibid (apa-ibid.tex)"
	# printf "%s\n" "\import{$STLDIR/apa-ibid.tex}"
	cat $STLDIR/apa-ibid.tex

	#
	#	END PREAMBLE
	#
	write_comment "CANCEL DATE COMMAND"
	printf "%s\n" "\date{}"			
}
#	TITLE PAGE
function make_title()
{
	write_comment "TITLE PAGE"
	printf "%s\n"   "\begin{titlepage}"
	printf "\t%s\n" "\centering"
	printf "\t%s\n" "\vspace{4cm}"
	printf "\t%s\n" "$TITLE \par"
	printf "\t%s\n" "$ST \par"
	printf "\t%s\n" "\vspace{$MARGIN}"
	printf "\t%s\n" "by \par"
	printf "\t%s\n" "\vspace{2cm}"
	printf "\t%s\n" "$AUTHOR \par"
	printf "\t%s\n" "\vspace{$MARGIN}"
	printf "\t%s\n" "\vfill"
	printf "\t%s\n" "${DISSHEADER[0]} \par"
	printf "\t%s\n" "${DISSHEADER[1]} \par"
	printf "\t%s\n" "${DISSHEADER[2]} \par"
	printf "\t%s\n" "${DISSHEADER[3]} \par"
	printf "\t%s\n" "${DISSHEADER[4]} \par"
	printf "\t%s\n" "${DISSHEADER[5]}"
	printf "\t%s\n" "\vspace{$MARGIN}"
	printf "\t%s\n" "\vfill"
	printf "\t%s\n" "\raggedleft"
	printf "\t%s\n" "{\hfill\hrulefill\par}"
	printf "\t%s\n" "$ADVISOR \par"
	printf "\t%s\n" "\vspace{$MARGIN}"
	printf "%s\n"   "\end{titlepage}"
	printf "%s\n"   "\newpage"
}
#	COPYRIGHT
function make_copyright()
{
	write_comment "COPYRIGHT PAGE"
	printf "%s\n" "\begin{center}"
	printf "\t%s\n" "\setlength{\parskip}{0pt}"
	printf "\t%s\n" "\copyright{} $AUTHOR\par"
	printf "\t%s\n" "$COPYRIGHT"
	printf "%s\n" "\end{center}"
	printf "%s\n" "\newpage"
}

#	BLANKPAGE
function make_page()
{
	write_comment "$1 PAGE"
	printf "%s\n" "$2"
	printf "%s\n" "\newpage"
}

#	EXTRA STUFF
function make_extra()
{
	write_comment "BEGIN EXTRAS"



	write_comment "DEDICATION PAGE"
	printf "\n%s\n" "\chapter{Dedication}"
	
	printf "%s\n" "\setcounter{page}{4}"

	cat $FMTDIR/dedication.tex 
	printf "\n%s\n" "\newpage"

	write_comment "ACKNOWLEDGEMENTS PAGE"
	printf "\n%s\n" "\chapter{Acknowledgements}"
	cat $FMTDIR/acknowledgements.tex 
	printf "\n%s\n" "\newpage"

	write_comment "PREFACE PAGE"
	printf "\n%s\n" "\chapter{Preface}"
	cat $FMTDIR/preface.tex
	printf "\n%s\n" "\newpage"

	write_comment "END EXTRAS"


}
#	PLACE FRONTMATTER CREATORS IN ONE ROUTINE
function make_frontmatter()
{
	printf "%s\n" "\pagestyle{empty}" 
	printf "%s\n" "\frontmatter"
	
	make_title
	make_copyright
	make_page "FRONTISPIECE" "\\centerline{\\includegraphics[width=1\\textwidth]{$FRONTIMG}}"
	make_page "BLANK" "\\clearpage"

	printf "%s\n" "\pagenumbering{roman}"
	printf "%s\n" "\pagestyle{plain}"
	
	make_extra

}

function make_tocs()
{
	write_comment "TABLE OF CONTENTS"
	
	printf "%s\n" "\tableofcontents"
	
	# https://tex.stackexchange.com/questions/48509/insert-list-of-figures-in-the-table-of-contents
	write_comment "LIST OF FIGURES"

	printf "%s\n" "\cleardoublepage"
	printf "%s\n" "\phantomsection"
	printf "%s\n" "\addcontentsline{toc}{chapter}{List of Figures}"
	printf "%s\n" "\cleardoublepage"
	printf "%s\n" "\listoffigures"
	

	write_comment "LIST OF TABLES"

	printf "%s\n" "\cleardoublepage"
	printf "%s\n" "\phantomsection"
	printf "%s\n" "\addcontentsline{toc}{chapter}{List of Tables}"
	printf "%s\n" "\cleardoublepage"
	printf "%s\n" "\listoftables"
	
	printf "%s\n" "\newpage"
	
	write_comment "END FRONTMATTER"
}


#	this is here so that \mainmatter is printed only once
printmainmatter=0

function make_from_arrays()
{
	local arr=("$@")
	local type=''
	local path=''	
	local name=''	
	local file=''
	local prev=''
	local bn=''

	for ((i = 0; i < ${#arr[@]}; i+=4))
	do
		type=${arr[$i]}
		path=${arr[$((i+1))]}
		name=${arr[$((i+2))]}
		file=`basename $path .tex`
		prev=`dirname "$path"`


		if grep -q "Abstract" <<< "$name"
		then
			write_comment "BEGIN $type: $name"
			printf "%s\n" "\\$type{$name}"
			printf "%s\n" "\addcontentsline{toc}{${type//\*}}{$name}"
		else
			#	IT IS NO LONGER THE ABSTRACT SECTION, PRINT LABELS
			if [[ $printmainmatter == 0 ]]
			then
				if [[ $TABLE_DISABLE == 0 ]]
				then
					# make the table of contents first
					make_tocs
				fi
				printf "%s\n" "\mainmatter"
				printf "%s\n" "\pagenumbering{arabic}"
				printmainmatter=1
			fi
			write_comment "BEGIN $type: $name ----"
			printf "%s\n" "\\$type{$name}"
			# 	CUSTOMIZE LABELS
			if ! grep -q "abstract" <<< "$file"
			then
				# it is a subsection
				label=$file
			else
				if ! grep -q "sub" <<< "$prev"
				then
					# it is a chapter
					bn=`basename $prev`
				else
					# it is a section
					bn=`dirname $prev`
				fi
				label=`basename $bn`
			fi
			printf "%s\n" "\label{$label}"
			# 	CHECK (*) AND ADD LINE TO TOC FOR UNOREDERED SECTIONS
			if grep -q "*" <<< "$type"; then
				printf "%s\n" "\addcontentsline{toc}{${type//\*}}{$name}"
			fi
		fi

		#	RESET GLOSSARY ENTRIES
		printf "\n%s\n" "\glsresetall"
		#	DUMP FILE CONTENTS TO OUTPUT
		cat $path
		
		write_comment "END $type: $name"
	done
}

#	BACKMATTER FROM SIMPLE ARRAY
function make_backmatter()
{
	printf "%s\n" "{"
	for i in ${backmatter[@]}
	do
		printf "%s\n" "\\$i"
	done
	printf "%s\n" "}"
}
# #	APPENDIX FROM SIMPLE ARRAY
# function make_appendix()
# {
# 	printf "%s\n" "{"
# 	for ((i = 0; i < ${#STRUCT[@]}; i+=4))
# 	do
# 		printf "%s\n" "\\$i"
# 	done
# 	printf "%s\n" "}"
# }


#	PUT IT ALL TOGETHER
function make_latex()
{
	local m=$MAINTEX
	TABLE_DISABLE=0
	print_comment "make_latex(): Making $m..."
	#
	#	REPLACE OLD FILE AND BEGIN
	#
	write_comment "BEGIN: Latex root"	1	 > $m
	#
	#	PREAMBLE
	#
	make_preamble 							>> $m
	#
	#	BEGIN DOCUMENT
	#
	write_comment "BEGIN: Document"			>> $m
	printf "%s\n" "\begin{document}" 		>> $m
	#
	#	FRONT MATTER
	#
	make_frontmatter 						>> $m
	#
	#	RANDOM \Large COMMAND SO THAT FONT LOOKS NICER...
	#	LATER: Remove or find a better way to do this
	#
	# printf "%s\n" "\\$size" 				>> $m

	#
	#	MAINMATTER
	#
	#	GET ALL FILE STRUCTURE FROM "STRUCT" ARRAY
	#
	make_from_arrays "${STRUCT[@]}" 		>> $m

	#
	#	APPENDIX
	#
	# printf "%s\n" "\appendix"				>> $m
	# make_from_arrays "${APPENDIX[@]}" 		>> $m

	#
	#	BACKMATTER
	#
	make_backmatter							>> $m

	printf "%s\n" "\end{document}"			>> $m
}

#	COMPILE main Latex file
function compile_latex()
{
	local m=$MAINTEX
	print_comment "compile_latex(): Compiling $m..."
	#	MAKE FIRST RUN
	print_comment "compile_latex(): pdflatex"
	pdflatex $LATEXFLAGS "$m" 				> /tmp/tex
	#	MAKE THE GLOSSARIES
	print_comment "compile_latex(): makeglossaries"
	makeglossaries "${NAME}" 				> /tmp/glo
	#	MAKE THE BIBLIOGRAPHY FOR THE *.AUX FILE
	print_comment "compile_latex(): biber"	
	biber "${NAME}" 						> /tmp/bib
	#	MAKE THE 3RD RUN
	print_comment "compile_latex(): pdflatex"
	pdflatex $LATEXFLAGS "$m" 				> /tmp/tex
	#	MAKE THE LAST RUN (VERBOSE)
	print_comment "compile_latex(): pdflatex"
	pdflatex $LATEXFLAGS "$m"
}

#	MAKE PAPER FROM SUBSECTION
function make_paper()
{
	local m=${PAPERTEX}
	TABLE_DISABLE=1
	print_comment "make_paper(): Making $m..."
	write_comment "BEGIN: Paper root"		>  $m
	make_preamble "${PAPERBIB}"				>> $m
	write_comment "BEGIN: Document"			>> $m
	printf "%s\n" "\begin{document}" 		>> $m
	# make_frontmatter 						>> $m
	make_from_arrays "${STRUCT[@]:((17*4)):((20))}"	>> $m
	make_backmatter							>> $m
	printf "%s\n" "\end{document}"			>> $m
}

#	COMPILE PAPER
function compile_paper()
{
	local m=${PAPERTEX}

	print_comment "compile_paper(): Compiling $m..."
	#	MAKE FIRST RUN
	print_comment "compile_paper(): pdflatex"
	pdflatex $LATEXFLAGS "$m" 				> /tmp/tex-p
	#	MAKE THE GLOSSARIES
	print_comment "compile_paper(): makeglossaries"
	makeglossaries "${PNAME}" 				> /tmp/glo-p
	#	MAKE THE BIBLIOGRAPHY FOR THE *.AUX FILE
	print_comment "compile_paper(): biber"	
	biber "${PNAME}" 						> /tmp/bib-p
	#	MAKE THE 3RD RUN
	print_comment "compile_paper(): pdflatex"
	pdflatex $LATEXFLAGS "$m" 				> /tmp/tex-p
	#	MAKE THE LAST RUN (VERBOSE)
	print_comment "compile_paper(): pdflatex"
	pdflatex $LATEXFLAGS "$m"
}



function make_readme()
{
	local pdf="${NAME}.pdf"
	local doc="${NAME}.docx"
	local csv="${NAME}.csv"
	local out="outline.txt"

	printf "\n%s\n" "# $TITLE"
	printf "\n%s\n" "## $ST"
	printf "\n%s\n" "---"
	printf "\n%s\n" "### Author"
	printf "%s\n" "$AUTHOR"
	printf "\n%s\n" "### Copyright"
	printf "%s\n" "$COPYRIGHT"
	printf "\n%s\n" "### Header"
	for i in "${DISSHEADER[@]}"
	do
		printf "%s " "$i"
	done
	printf "\n%s\n" "### Advisor"
	printf "%s\n" "$ADVISOR"
	printf "\n%s\n" "### Committee"
	for i in "${COMMITTEE[@]}"
	do
		printf "%s\n" "- $i"
	done
	printf "\n%s\n" "---"
	printf "\n%s\n" "## Read"
	printf "\n%s\n" "### Versions"
	printf "%s\n" "- [website (html)]($ONLINE/online) $WEBNOTE"
	printf "%s\n" "- [print (pdf)](output/$pdf)"
	printf "%s\n" "- [print (docx)](output/$doc)"
	printf "%s\n" "- [code repository]($REPO)"
	printf "\n%s\n" "### Outline"
	printf "%s\n" "- [toc (txt)](output/$out)"
	printf "%s\n" "- [toc (csv)](output/$csv)"
	printf "\n%s\n" "### Log"
	printf "%s\n" "- Word count: $TOTALWORDS ($NEWWORDS)"
	printf "%s\n" "- Last updated: $DATE"
}

function make_index()
{
	print_comment "make_index(): Making README.md ..."

	local title="\"${TITLE//' '/_}\""
	local flags="-s -f markdown -t html --metadata pagetitle=$title"
	
	make_readme > README.md
}

function copy_img_and_css()
{
	imgsrc=`grep -o '<img[^>]*src="[^"]*"' ${NAME}.html | 
			cut -f 2 -d\" | cut -f 2 -d:`
	rsync $imgsrc $DISSDIR/img
	cp $STLDIR/pandoc.css $DISSDIR/styles
}

function make_html()
{
	#	LATER: Make a headless .tex for easier HTML  
	print_comment "make_html(): Making html..."

	#	extramacro.tex capitalizes \gls{} entries
	#	pandoc does not read glossaries!
	pandoc $STLDIR/extramacro.tex $MAINTEX $PANDOCFLAGS --metadata pagetitle="\"${TITLE//' '/_}\"" --css=$PANDOCSTYLE -o ${NAME}.html
	# pandoc $MAINTEX $PANDOCFLAGS -o ${NAME}.html
	sed -e "s|$IMGDIR|../img|g; s|$STLDIR|../styles|g" ${NAME}.html > ${DISSDIR}/index.html
}

function make_docx()
{
	print_comment "make_docx(): Making docx..."
	pandoc $STLDIR/extramacro.tex $MAINTEX $PANDOCFLAGS -f latex -t docx -o ${ROOTDIR}/${NAME}.docx
	# pandoc ${NAME}.html -f html -t docx -o ${ROOTDIR}/${NAME}.docx
	mv ${NAME}.html $TMPDIR # just place original html file on the temp dir
}

function tidy_up()
{
	if [[ $1 ]]
	then
		mv ${ROOTDIR}/${1}.{pdf,tex,bib,csv,docx} ${OUTDIR}
		mv ${ROOTDIR}/${1}.* ${TMPDIR}
	else
		mv ${ROOTDIR}/${NAME}.{pdf,tex,bib,csv,docx} ${OUTDIR}
		mv ${ROOTDIR}/${NAME}.* ${TMPDIR}
	fi
}

function count_words()
{
	print_comment "count_words(): Counting words..."
	echo "words,title,path"									> $WCFILE
	local c=0

	for ((i = 0; i < ${#STRUCT[@]}; i+=4))
	do
		type=${STRUCT[$i]}
		path=${STRUCT[$((i+1))]}
		name=${STRUCT[$((i+2))]}
		words=${STRUCT[$((i+3))]}
		printf "%-6d\t%-20s\t%s\n" "$words" "$name" "$path" >> $WCFILE
		((c=$c+$words))
	done
	TOTALWORDS=$c
	# print_comment "$title: $s | TARGET: $starg | REMAIN: $rem | SECTION TARGET: $trg | SECTIONS: $ssize "
	# printf "%-30s,%-10s,%s\n" "TITLE" "COUNT" "REMAINS" | column -t -s,
	# echo $LINE
	# 	for ((i = 0; i < ${#sec[@]}; i+=2))
	# 	do
	# 		if [[ "${sec[$((i+1))]}" ]]; then
	# 			cn="${sec[$((i+1))]}"
	# 			na="${sec[$i]}"
	# 			p=$((cn-$trg))
	# 			if [[ $p > 0 ]]; then color=2; else color=1; fi
	# 			b=$(tput setaf $color)
	# 			n=$(tput sgr0)
	# printf "%-30s,%-10d,%s\n" "$na" "$cn" "$b$p$n" | column -t -s,
	# printf "%s,%s,%s,%s,%s,%s\n" "$title" $s "$na" $trg $cn "$p" >> $WCFILE
	# 		fi
	# 	done
	# done
	# print_comment "$c words found. See:\
	# <output/`basename $WCFILE`> for more information." 
}

function help_message()
{
	print_comment
	print_comment "DISSERTATION WRITING UTILITIES | $AUTHOR"
	print_comment "$USAGE" 
}

function wrong_args()
{
	echo "$(tput setaf 1)<$1> is not a valid argument$(tput sgr0)"
	echo "run with -h or --help for more options."
}

function delete_temp()
{
	if [ -e ${TMPDIR}/${NAME}.log ]
	then
		rm ${TMPDIR}/${NAME}.*
	fi
}

function compare()
{
	local w=( 0 0 )
	local c=0
	local f0='./'
	local f1=''
	local i=0

	if [[ $1 ]]
	then
		f0=$1
	fi

	if [[ ! $2 ]]
	then
		#	Find next backup item nubmer
		if [[ -d ../backup/bin_1 ]] ; then
			for dirs in ../backup/* ; do 
				((i++))
			done
		fi
		f1=../backup/bin_${i}
	else
		f1=$2
	fi

	print_comment "compare(): Comparing $f0 with $f1 ..."

	for i in $f0 $f1
	do
		w[$c]=`cat "${i}/output/main.csv"	| 
			   cut -f 1 					| 
			   awk '{s+=$1} END {print s}'`
		((c++))
	done

	NEWWORDS=$((w[0]-${w[1]}))
}

function update_repo()
{
	print_comment "Updating $REPO"
	# cd $DISSDIR/..
	git add .
	git commit -m "update"
	git push
	# cd  $ROOTDIR
}


function main()
{
	delete_temp
	make_bib
	make_latex
	compile_latex
	make_html
	make_docx
	count_words
	tidy_up
	compare
	open "output/${NAME}.pdf"
	make_index
	update_repo
	print_comment "... finished with main()"
}