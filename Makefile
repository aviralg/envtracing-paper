MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECTDIR := $(dir $(MAKEFILE_PATH))

ANALYSIS := corpus
DATADIR := $(PROJECTDIR)data
GRAPHDIR := $(PROJECTDIR)graphs
MACRODIR := $(PROJECTDIR)macros

# Tools
PDFLATEX = pdflatex
BIBTEX = bibtex
RM = rm -f
R = R

# Targets
all: main.pdf open

open: main.pdf
	open main.pdf

main.pdf: main.tex
	$(PDFLATEX) main && $(BIBTEX) main

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

analysis:
	$(R) --slave -e "rmarkdown::render('$(ANALYSIS).Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)'))"

.PHONY: all open clean analysis

# Include auto-generated dependencies
-include *.d
