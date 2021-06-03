MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECTDIR := $(dir $(MAKEFILE_PATH))

ANALYSIS := corpus
DATADIR := $(PROJECTDIR)data
GRAPHDIR := $(PROJECTDIR)graphs
MACRODIR := $(PROJECTDIR)macros
TABLEDIR := $(PROJECTDIR)tables

# Tools
PDFLATEX = pdflatex
BIBTEX = bibtex
RM = rm -f
R = R

# Targets
all: main.pdf open

open:
	open main.pdf

main.pdf:
	$(PDFLATEX) main && $(BIBTEX) main

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

analysis:
	$(R) --slave -e "rmarkdown::render('analysis/$(ANALYSIS).Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)', tabledir = '$(TABLEDIR)'))"

classification:
	make analysis ANALYSIS=classification

new_env:
	make analysis ANALYSIS=new_env

corpus:
	make analysis ANALYSIS=corpus

.PHONY: all open main.pdf clean analysis

# Include auto-generated dependencies
-include *.d
