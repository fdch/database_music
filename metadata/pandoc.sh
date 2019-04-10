LATEXFLAGS="\
-interaction nonstopmode \
-file-line-error"

PANDOCBIBTYPE=$STLDIR/author-date.csl

PANDOCSTYLE=$STLDIR/pandoc.css

PANDOCFLAGS="\

-s --wrap=none \

--katex

--toc --toc-depth=4 \

--bibliography=$MAINBIB \

--csl=$PANDOCBIBTYPE \

"