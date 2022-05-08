.PHONY: clean sample.pdf

sample.pdf:
	latexmk -shell-escape sample

clean:
	@rm -f *.dvi *.aux *.fls *.ps *.log *.fdb_latexmk *~ *.out *.blg *.bbl *.synctex.gz *.bak *.xmpi *.xmpdata
	@rm -rf _minted-*
	@ls *.pdf | grep -v '^sample' | xargs rm

pip:
	pip install pygments-mathematica
