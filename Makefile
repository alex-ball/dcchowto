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
	pdflatex -shell-escape -recorder -interaction=nonstopmode $(NAME).dtx > /dev/null
tmp: $(NAME).pdf $(EG).md
	cp $(EG).md $(EG)-tmp.md
	echo -e "\n# References\n\n" >> $(EG)-tmp.md
pdf: tmp $(EG)-tmp.md $(EG).bib $(NAME)-apa.csl
	pandoc -s -S --latex-engine=lualatex --biblio $(EG).bib --csl $(NAME)-apa.csl -N -V fontsize=11pt -V papersize=a4paper -V lang=british -V geometry:hmargin=3cm -V geometry:vmargin=2.5cm -V mainfont=Charis\ SIL -V monofont=DejaVu\ Sans\ Mono $(EG)-tmp.md -o $(EG)-preview.pdf
html: tmp $(EG)-tmp.md $(EG).bib $(NAME)-apa.csl
	pandoc -s -S --biblio $(EG).bib --csl $(NAME)-apa.csl $(EG)-tmp.md -o $(EG).html
	perl -0777 -p -i -e 's@<h5 id="([^"]+)">([^<]+)</h5>@<h6 id="\1">\2</h6>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h4 id="([^"]+)">([^<]+)</h4>@<h5 id="\1">\2</h5>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h3 id="([^"]+)">([^<]+)</h3>@<h4 id="\1">\2</h4>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h2 id="([^"]+)">([^<]+)</h2>@<h3 id="\1">\2</h3>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h1 id="([^"]+)">([^<]+)</h1>@<h2 id="\1">\2</h2>@ig' $(EG).html
	perl -0777 -p -i -e 's@<h1>References</h1>@<h2>References</h2>@ig' $(EG).html
dtp: $(NAME).pdf $(EG).md $(EG).bib $(NAME).latex
	pandoc -s -S --biblatex -V biblio-files=$(EG).bib --template=$(NAME) $(EG).md -t latex -o $(EG).tex
	latexmk -pdflatex="pdflatex -synctex=1 -interaction batchmode %O %S" -pdf $(EG).tex
clean:
	rm -f $(NAME).{aux,cod,fdb_latexmk,fls,glo,gls,hd,idx,ilg,ind,ins,log,out,pyg}
	rm -f $(EG).{aux,bbl,bcf,blg,fdb_latexmk,fls,log,out,run.xml,synctex.gz}
	rm -f $(EG)-tmp.md
distclean: clean
	rm -f $(NAME).{cls,pdf,latex} $(NAME)-apa.csl $(EG).{bib,html,md,pdf,tex} README
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
