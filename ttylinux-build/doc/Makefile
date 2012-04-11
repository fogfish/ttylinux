# This file is part of the ttylinux software.
# The license which this software falls under is GPLv2 as follows:
#
# Copyright (C) 2012-2012 Douglas Jerome <douglas@ttylinux.org>
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA


# *****************************************************************************
#
# FILE DESCRIPTION
#
#       This is the makefile used in making a ttylinux distribution.
#
# CHANGE LOG
#
#       08apr12 drj     Started with Pascal Schmidt's makefile.
#
# *****************************************************************************


# *****************************************************************************
# Make Targets
# *****************************************************************************

.PHONY: help
.PHONY: clean
.PHONY: temp_tex html_multi html_single
.PHONY: ug dvi html pdf ps

# -----------------------------------------------------------------------------
# -- Default Target
# -----------------------------------------------------------------------------

help:
	@echo ""
	@echo "ug       - make the User Guide documents: dvi html pdf ps"
	@echo "dvi      - make dvi (DeVice Independent) ... User_Guide.dvi"
	@echo "html     - make html ....................... User_Guide.html"
	@echo "pdf      - make pdf ........................ User_Guide.pdf"
	@echo "ps       - make postscript ................. User_Guide.ps"

# -----------------------------------------------------------------------------
# -- Housekeeping
# -----------------------------------------------------------------------------

clean:
	rm -f temp.*
	rm -f User_Guide.aux User_Guide.log User_Guide.toc
	rm -f User_Guide.dvi User_Guide.html User_Guide.pdf User_Guide.ps
	rm -rf single/ multi/

# -----------------------------------------------------------------------------
# -- HTML Format Steps
# -----------------------------------------------------------------------------

temp_tex:
	rm -f temp.*
	sed -e 's:\\url{:{\\tt :g'				\
		-e 's|\([^\\]\)_|\1\\_|g'			\
		-e 's|begin{lstlisting}|begin{verbatim}|g'	\
		-e 's|end{lstlisting}|end{verbatim}|g'		\
		User_Guide.tex >temp.tex
	latex temp.tex

html_multi:
	rm -rf multi/
	latex2html				\
		-local_icons			\
		-nocontents_in_navigation	\
		-nofootnode			\
		-noaddress			\
		-noinfo				\
		-show_section_numbers		\
		-html_version 4.0		\
		-lcase_tags			\
		-dir multi			\
		-mkdir				\
		temp.tex
	rm -f multi/WARNINGS multi/*.pl multi/temp.html
	mv multi/temp.css multi/User_Guide.css
	for _file in "multi/*.html"; do					\
		sed -e 's|temp.html|index.html|g'    -i $${_file};	\
		sed -e 's|temp.css|User_Guide.css|g' -i $${_file};	\
		sed -e 's|="temp"|="User_Guide"|g'   -i $${_file};	\
	done

html_single:
	rm -rf single/ User_Guide.html
	latex2html				\
		-split 0			\
		-local_icons			\
		-nonavigation			\
		-nofootnode			\
		-noaddress			\
		-noinfo				\
		-show_section_numbers		\
		-html_version 4.0		\
		-lcase_tags			\
		-dir single			\
		-mkdir				\
		temp.tex
	sed -e 's|temp.html|User_Guide.html|' single/index.html >User_Guide.html
	rm -rf single/

# -----------------------------------------------------------------------------
# -- Document Targets
# -----------------------------------------------------------------------------

ug:	clean html pdf
	rm -f User_Guide.aux User_Guide.log User_Guide.toc
	@echo ""
	@echo ""
	@echo "=> New Files"
	@ls -l User_Guide.{html,pdf} multi/index.html
	@echo ""

dvi:
	latex User_Guide.tex
	latex User_Guide.tex
	latex User_Guide.tex

html:	temp_tex html_multi html_single
	find . -name "*.html" -exec sed -e 's|\\_|_|g' -i {} \;
	rm temp.*

pdf:
	pdflatex User_Guide.tex
	pdflatex User_Guide.tex
	pdflatex User_Guide.tex

ps:	dvi
	dvips -o User_Guide.ps User_Guide.dvi

