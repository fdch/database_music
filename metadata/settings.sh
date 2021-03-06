class=book
paper=letterpaper
side=oneside
defimgfmt=png # default image format
fontsize=12pt #10pt #14pt
fontface=times #courier
size= #Large (this radically changes the fontsize)

classparams="
	${fontsize},
	${paper},
	${side},
	notitlepage
"

geometryparams="
	left=$MARGIN,
	right=$MARGIN,
	top=$MARGIN,
	bottom=1.5in
"

hyperrefparams="
	unicode=true, 
	bookmarks=true, 
	bookmarksnumbered=false, 
	bookmarksopen=false, 
	breaklinks=true, 
	hidelinks,
	colorlinks=false,
	linkbordercolor={white},
"
	# linkcolor={red!50!blue},
	# citecolor={blue!50!black},
	# urlcolor={red!50!black}

glossariesparams="
	toc,
	acronym
"

bibstyle=ieeetr

biblatexparams="
	backend=biber,
	sorting=nyt,
	safeinputenc,
	pagetracker,
	style=$CITATIONSTYLE,
	dashed=false,
	ibidtracker=constrict
"


packages=(
	"inputenc"	 "utf8"
	"fontenc" 	 "T1"
	"babel"		 "english"
	"geometry"	 "${geometryparams}"
	"import"     ""
	"biblatex"	 "${biblatexparams}"
	"ulem" 		 "normalem"
	"xcolor"	 ""
	"csquotes"	 ""
	"listings"	 ""
	"$fontface"  ""
	"lscape"	 ""
	"placeins" 	 ""
	"graphicx"	 ""
	"xparse"	 ""
	"fancyhdr"	 ""
	"lipsum"	 ""
	"etoolbox"   ""
	"setspace"	 ""
	"cancel"	 ""
	# Move hyperref to the last, with glossaries after:
	# https://tex.stackexchange.com/questions/495360/adding-page-number-to-table-of-contents
	"hyperref"	 "${hyperrefparams}"
	"glossaries" "${glossariesparams}"
)

backmatter=(
	"backmatter"
	"singlespacing"
	# "glsaddall"
	"setglossarysection{part}"
	"printglossaries"
	# "phantomsection"
	# "setlength{\\parskip}{4em}"
	"printbibliography"
	"addcontentsline{toc}{part}{Bibliography}" # this gives an error
	# could it be like this?
	# \addcontentsline{\$}{toc}{chapter}{Bibliography}
)
#	CUSTOM COMMANDS
newcommands=(
	# NAME 		ARGUMENTS 	FORMAT
	"see"		"1"			"(See \\ref{#1})"
	"fsee"		"1"			"(See Figure \\ref{img:#1})"
	"lsee"		"1"			"(See Listing \\ref{lst:#1})"
	"im" 		"0"			"[emphasis added] "
	"obj"		"1"			"\\framebox{{\\small\\textbf{\\texttt{#1}}}}"
	"poscite"   "1"         "\\citeauthor{#1}'s (\\citeyear{#1})"
	"inspire"   "1"         "{{\\small\\textit{inhale} (#1)} \\par}"
	"img"       "4"         
"
\\begin{figure}[!htbp]
\\centering
\\includegraphics[width=#2\\textwidth]{$IMGDIR/#1.$defimgfmt}
\\caption{#4}
\\label{img:#1}
#3
\\end{figure}
\\FloatBarrier
"
)

extrasettings="

%	MAKE = INTO \LEFTARROW INSIDE LISTINGS

\\lstset{columns=fullflexible,
        mathescape=true,
        literate=
               {=}{$\\leftarrow{}$}{1}
               {==}{$={}$}{1},
        morekeywords={if,then,else,return}
        }

%	DOUBLE SPACING

\\doublespacing

%	ADD SPACE BETWEN PAGE NUMBERS AND LAST LINE

\\setlength{\\footskip}{1.5\\baselineskip}
\\setlength{\\parindent}{4em}

%	MAKE ALL itemize, quote AND lstlisting ENVIRONMENTS SINGLESPACED

\\makeatletter
\\AtBeginEnvironment{itemize}{
	\\if@nobreak\\vspace*{-\\topskip}\\fi
	\\singlespacing}
\\makeatother

\\makeatletter
\\AtBeginEnvironment{quote}{
	\\if@nobreak\\vspace*{-\\topskip}\\fi
	\\singlespacing}
\\makeatother

\\makeatletter
\\AtBeginEnvironment{lstlisting}{
	\\if@nobreak\\vspace*{-\\topskip}\\fi
	\\singlespacing}
\\makeatother
"


# %	MAKE GLOSSARY DUAL ENTRIES WITH ACRONYMS


# \\DeclareDocumentCommand{\\newdualentry}{ O{} O{} m m m m } {
#   \\newglossaryentry{gls-#3}{name={#5},text={#5\\glsadd{#3}},
#     description={#6},
#     #1
#   }
#   \\makeglossaries
#   \\newacronym[see={[Glossary:]{gls-#3}},#2]{#3}{#4}{#5\\glsadd{gls-#3}}
# }



# "



