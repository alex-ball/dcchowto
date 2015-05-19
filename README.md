# dcchowto: A LaTeX class for DCC How-to Guides

This class is useful for typesetting DCC How-to Guides. It comes with some
support files to make it possible to generate camera-ready copy from Markdown
source. The Markdown could then be used to generate an HTML version as well.

## Installation

### Dependencies

To be able to compile the class from source, you will need a recent TeX
distribution, including `biblatex`, `biber`, and sundry other packages.

To generate the sample document from the makefile, you will need the Make
utility and Perl.

To generate the preview PDF from the makefile as it stands,
you will need LuaLaTeX and the fonts
[Charis SIL](http://scripts.sil.org/cms/scripts/page.php?item_id=CharisSIL_download)
and [DejaVu Sans Mono](http://dejavu-fonts.org/wiki/Download).
You can remove that dependency by editing the makefile.

### Automated way

A makefile is provided which you can use with the Make utility:

  * Running `make` generates the derived files
      - README
      - dcchowto.pdf
      - dcchowto.cls
      - dcchowto-template.html
      - dcchowto-template.latex
      - dcchowto-apa.csl
      - dcchowto-example.md
      - dcchowto-example.bib
      - dcchowto-fig-doi.html
      - dcchowto-fig-doi.tex
      - dcchowto-fig-dual-licence.html
      - dcchowto-fig-dual-licence.tex
  * Running `make html` generates a sample HTML document from the example code.
  * Running `make pdf` generates a sample preview PDF file from the example code.
  * Running `make dtp` generates a sample camera-ready PDF file from the example code.
  * Running `make inst` installs the files in the user's TeX tree.
  * Running `make install` installs the files in the local TeX tree.

### Manual way

 1. Compile dccpaper.dtx just as you would a normal LaTeX file.
 2. Generating the sample documents from the sample code is somewhat fiddly,
    so if you are not comfortable working through the makefile and translating
    what is going on, it might be better not to bother. If you just need some
    hints, though, here they are:
      * Variables like `$(NAME)` get replaced with the values at the top of the
        file (`dcchowto` in this case).
      * Before working on the HTML or preview PDF documents, you need to follow
        the instructions for making `$(EG)-tmp.md`, i.e.
        `dcchowto-example-tmp.md`.
      * `cp` means copy.
      * The lines of Perl perform regular expression search and replace.
 3. Move the files to your TeX tree as follows:
      * `source/latex/dcchowto`: `dcchowto.dtx`, `dcchowto.ins`;
      * `tex/latex/dcchowto`: `dcchowto.cls`, `dcchowto-apa.csl`,
        `dcchowto-template.html`, `dcchowto-template.latex`;
      * `doc/latex/dcchowto`: `dcchowto.pdf`, `dcchowto-example.bib`,
        `dcchowto-example.md`, `dcchowto-fig-doi.html`, `dcchowto-fig-doi.tex`,
        `dcchowto-fig-dual-licence.html`, `dcchowto-fig-dual-licence.tex`,
        and if you generated them, `dcchowto-example.html`,
        `dcchowto-example-preview.pdf`, `dcchowto-example.pdf`.
 4. You may then have to update your installation's file name database before TeX and friends can see the files.

## Licence

This work consists of the file dcchowto.dtx and a Makefile.

This work may be distributed and/or modified under the conditions of the
[LaTeX Project Public License (LPPL)](http://www.latex-project.org/lppl.txt),
either version 1.3c of this license or (at your option) any later version.

This work is "maintained" (as per LPPL maintenance status) by
[Alex Ball](http://alexball.me.uk/).

Please note that the generated file dcchowto-apa.csl is based on the apa.csl
file written by Simon Kornblith, with contributions from Bruce D'Arcus,
Curtis M. Humphrey, Richard Karnesky and Sebastian Karcher, and in its
standalone form is separately licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International
Licence](http://creativecommons.org/licenses/by-sa/4.0/).

