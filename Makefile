.PHONY: clean sample.pdf

sample.pdf:
	latexmk -shell-escape sample
	latexmk -shell-escape sample_a
	latexmk -shell-escape sample_x

sample_note.pdf:
	latexmk -shell-escape sample_note

sample_en.pdf:
	latexmk -shell-escape sample_en
sample_ja.pdf:
	latexmk -shell-escape sample_ja

clean:
	@rm -f *.dvi *.aux *.fls *.ps *.log *.fdb_latexmk *~ *.out *.blg *.bbl *.synctex.gz *.bak *.xmpi *.xmpdata
	@rm -rf _minted-*
	@ls *.pdf | grep -v '^sample' | xargs rm

pip:
	pip install pygments-mathematica
