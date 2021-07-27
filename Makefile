MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
PROJECTDIR := $(dir $(MAKEFILE_PATH))

ANALYSIS := corpus
DATADIR := $(PROJECTDIR)data
GRAPHDIR := $(PROJECTDIR)graphs
MACRODIR := $(PROJECTDIR)macros
TABLEDIR := $(PROJECTDIR)tables

MACROFILE := $(PROJECTDIR)macros.tex

# Tools
PDFLATEX = pdflatex
BIBTEX = bibtex
RM = rm -f
R = R

# Targets
all: main.pdf open

open:
	open main.pdf

main.pdf: merge-macros
	$(PDFLATEX) main && $(BIBTEX) main

clean:
	rm *~ *.log *.aux *.bbl *.out *.blg

merge-macros:
	R --slave -e "invisible(experimentr::merge_macros('$(MACRODIR)', '$(MACROFILE)'))"

analysis:
	$(R) --slave -e "rmarkdown::render('analysis/$(ANALYSIS).Rmd', 'html_document', params = list(datadir = '$(DATADIR)', graphdir = '$(GRAPHDIR)', macrodir = '$(MACRODIR)', tabledir = '$(TABLEDIR)'))"

usage-metrics:
	make analysis ANALYSIS=usage-metrics

allocation:
	make analysis ANALYSIS=allocation

classification:
	make analysis ANALYSIS=classification

new_env:
	make analysis ANALYSIS=new_env

corpus:
	make analysis ANALYSIS=corpus

event_seq:
	make analysis ANALYSIS=event_seq

call-stack:
	make analysis ANALYSIS=call-stack

side-effects:
	make analysis ANALYSIS=side-effects

.PHONY: all open main.pdf clean analysis

# Include auto-generated dependencies
-include *.d
