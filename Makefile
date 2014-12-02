NAME  = dcchowto
EG    = dcchowto-example
SHELL = bash
PWD   = $(shell pwd)
TEMP := $(shell mktemp -d)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
all:	$(NAME).pdf clean
	test -e README.md && pandoc README.md -t rst -o README || exit 0
$(NAME).pdf: $(NAME).dtx
	pdflatex -shell-escape -recorder -interaction=batchmode $(NAME).dtx >/dev/null
	if [ -f $(NAME).glo ]; then makeindex -q -s gglo.ist -o $(NAME).gls $(NAME).glo; fi
	if [ -f $(NAME).idx ]; then makeindex -q -s gind.ist -o $(NAME).ind $(NAME).idx; fi
	pdflatex -shell-escape -recorder -interaction=nonstopmode $(NAME).dtx > /dev/null
	pdflatex -shell-escape -recorder -synctex=1 -interaction=nonstopmode $(NAME).dtx > /dev/null
tmp: $(NAME).pdf $(EG).md
	cp $(EG).md $(EG)-tmp.md
	echo -e "\n# Notes {#sec:notes}\n\nBefore uploading to the DCC website, the order of the last three items should be reversed, i.e. 'Notes', then 'Further information', then 'Acknowledgements'.\n\n" >> $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\bgroup\\boxout@<div class="div_highlight" style="border-radius:8px;">@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\endboxout\\egroup@</div>@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\(end)?fillboxout@@ig' $(EG)-tmp.md
pdf: tmp $(EG).bib $(NAME)-apa.csl
	# The next line is peculiar to the particular sample content
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@\\footref{fn:valimiki}@ig' $(EG)-tmp.md
	pandoc -s -S --latex-engine=lualatex --biblio $(EG).bib --csl $(NAME)-apa.csl -N -V fontsize=11pt -V papersize=a4paper -V lang=british -V geometry:hmargin=3cm -V geometry:vmargin=2.5cm -V mainfont=Charis\ SIL -V monofont=DejaVu\ Sans\ Mono -V header-includes="\usepackage{footmisc}\usepackage[svgnames]{xcolor}\colorlet{dccblue}{Blue}\let\nonzeroparskip\relax\let\fullcite\textbf" $(EG)-tmp.md -o $(EG)-preview.pdf
html: tmp $(EG).bib $(NAME)-apa.csl
	perl -0777 -p -i -e 's@(?:\\begin\{figure\*?\}|\\bgroup\\figure|\\bgroup\\csname figure*\\endcsname)(?:\[[^\]]+\])?(.*?)\\caption\[([^\]]+)\]\{[^}]+\}\n\\label\{[^}]+\}\n\n(?:\\end\{figure\*?\}|\\endfigure\\egroup|\\endcsname figure*\endcsname\\egroup)@<div class="div_highlight" style="border-radius:8px;" id="\3">\1<p style="text-align:center;"><strong>Figure N:</strong> \2</p>\n\n</div>@igms' $(EG)-tmp.md
	perl -0777 -p -i -e 's@(?:\\begin\{figure\*?\}|\\bgroup\\figure|\\bgroup\\csname figure*\\endcsname)(?:\[[^\]]+\])?(.*?)\\caption\{([^}]+)\}\n\\label\{[^}]+\}\n\n(?:\\end\{figure\*?\}|\\endfigure\\egroup|\\endcsname figure*\endcsname\\egroup)@<div class="div_highlight" style="border-radius:8px;" id="\3">\1<p style="text-align:center;"><strong>Figure N:</strong> \2</p>\n\n</div>@igms' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\input\{([^}]+)\}@open+F,"$$1.html";join"",<F>@ige' $(EG)-tmp.md
	# The next 5 lines are peculiar to the particular sample content
	perl -0777 -p -i -e 's@\\footref\{fn:altman.king\}@<a href="#fn7" class="footnoteRef"><sup>[7]</sup></a>@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\footref\{fn:lawrence.etal\}@<a href="#fn8" class="footnoteRef"><sup>[8]</sup></a>@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\footref\{fn:green\}@<a href="#fn9" class="footnoteRef"><sup>[9]</sup></a>@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\footref\{fn:starr.gastl\}@<a href="#fn10" class="footnoteRef"><sup>[10]</sup></a>@ig' $(EG)-tmp.md
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@<a href="#fn55" class="footnoteRef"><sup>[55]</sup></a>@ig' $(EG)-tmp.md
	# General lines
	pandoc -s -S --toc --toc-depth=1 --biblio $(EG).bib --csl $(NAME)-apa.csl --template=$(NAME)-template $(EG)-tmp.md -o $(EG).html
	perl -0777 -p -i -e 's@<p></p>@@ig' $(EG).html
	perl -0777 -p -i -e 's@<h5 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h5>@<h6 id="\1">\2</h6>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h4 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h4>@<h5 id="\1">\2</h5>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h3 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h3>@<h4 id="\1">\2</h4>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h2 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h2>@<h3 id="\1">\2</h3>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h1 id="([^"]+)">(?:<a href="[^"]+">)?([^<]+)(?:</a>)?</h1>@<p class="back"><a href="#top"><img alt="Back to top" class="mceItem" height="16" src="http://www.dcc.ac.uk//sites/all/themes/dcc/images/arrow_up.png" title="Back to top" width="16" /></a></p>\n<h2 id="\1">\2</h2>@ig' $(EG).html
	perl -0777 -p -i -e 's@<div class="div_highlight" style="border-radius:8px;">\n<h1><a href="([^"]+)">([^<]+)</a></h1>@<div class="div_highlight" style="border-radius:8px;">\n<h2 id="\1">\2</h2>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h1><a href="#sec:refs">References</a></h1>@<h2 id="#sec:refs">References</h2>@ig' $(EG).html
	perl -0777 -p -i -e 's@<sup>(\d+)</sup>@<sup>[\1]</sup>@ig' $(EG).html
dtp: $(NAME).pdf $(EG).md $(EG).bib $(NAME)-template.latex
	pandoc -s -S --biblatex -V biblio-files=$(EG).bib --template=$(NAME)-template -V header-includes="\usetikzlibrary{positioning}" $(EG).md -t latex -o $(EG).tex
	# The next 8 lines are peculiar to the particular sample content
	perl -0777 -p -i -e 's@\\autocite\{altman\.king2007pss\}@\\footnote{\\fullcite{altman.king2007pss}\\label{fn:altman.king}}@i' $(EG).tex
	perl -0777 -p -i -e 's@\\autocite\{lawrence\.etal2008dp\}@\\footnote{\\fullcite{lawrence.etal2008dp}\\label{fn:lawrence.etal}}@i' $(EG).tex
	perl -0777 -p -i -e 's@\\autocite\{green2010wnp\}@\\footnote{\\fullcite{green2010wnp}\\label{fn:green}}@i' $(EG).tex
	perl -0777 -p -i -e 's@\\autocite\{starr\.gastl2011ims\}@\\footnote{\\fullcite{starr\.gastl2011ims}\\label{fn:starr.gastl}}@i' $(EG).tex
	perl -0777 -p -i -e 's@\\footref\(fn:valimiki\)@\\footref{fn:valimiki}@ig' $(EG).tex
	perl -0777 -p -i -e 's@\\autocite\{valimaki2003dlo\}@\\footnote{\\fullcite{valimaki2003dlo}\\label{fn:valimiki}}@i' $(EG).tex
	perl -0777 -p -i -e 's/\[\@adobe2010xmp\]/\\autocite{adobe2010xmp}/ig' $(EG).tex
	# General lines
	perl -0777 -p -i -e 's/\\item\[([^\]]+) \\autocite\{([^}]+)\}\]\n/\\item[\1]\n\\hskip-\\labelsep\\autocite{\2}\\hskip\\labelsep /ig' $(EG).tex
	perl -0777 -p -i -e 's@,\sURL:@, \\smallcaps{URL}:@igms' $(EG).tex
	perl -0777 -p -i -e 's@\\texttt\{\\textless\{\}\}@\$$\\langle\$$@ig' $(EG).tex
	perl -0777 -p -i -e 's@\\texttt\{\\textgreater\{\}\}@\$$\\rangle\$$@ig' $(EG).tex
	perl -0777 -p -i -e 's@\\fullcite\{([^}]+)\}\\autocite\{\1\}@\\fullcite{\1}@ig' $(EG).tex
	latexmk -pdflatex="pdflatex -synctex=1 -interaction batchmode %O %S" -pdf $(EG).tex
clean:
	rm -f $(NAME).{aux,cod,fdb_latexmk,fls,glo,gls,hd,idx,ilg,ind,ins,log,out,pyg,tcbtemp}
	rm -f $(EG).{aux,bbl,bcf,blg,fdb_latexmk,fls,log,out,run.xml,synctex.gz}
	rm -f $(EG)-tmp.md
distclean: clean
	rm -f $(NAME).{cls,pdf,synctex.gz} $(NAME)-apa.csl $(NAME)-template.{latex,html} $(EG).{bib,html,md,pdf,tex} $(EG)-preview.pdf README
inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp $(NAME).cls $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)
install: all
	sudo mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
	sudo cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
	sudo cp $(NAME).cls $(LOCAL)/tex/latex/$(NAME)
	sudo cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
zip: all
	mkdir $(TDIR)
	cp $(NAME).{pdf,cls,dtx} README $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)
