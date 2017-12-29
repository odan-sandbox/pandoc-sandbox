# ここにpdf化したいmarkdownが含まれるディレクトリを指定してください
MD_DIRS:=intro odan code_test

# 以下触らないこと
OUTDIR:=build
TEX_FILES:=$(foreach dir, $(MD_DIRS), $(OUTDIR)/$(dir).tex)
TARGET:=main.pdf


$(OUTDIR)/%.tex: %/*
	mkdir -p $(OUTDIR)
	$(eval DIR_NAME=$(word 1, $(dir $^)))

	$(eval MD_FILES=$(wildcard $(DIR_NAME)/*.md))

	$(eval BIB_FILE=$(DIR_NAME)/$(DIR_NAME).bib)
	$(eval CITE_OPTION=$(shell if [ -f $(BIB_FILE) ]; then echo --bibliography=$(BIB_FILE); else echo ; fi))

	pandoc $(MD_FILES) $(CITE_OPTION) --filter pandoc-crossref -M "crossrefYaml=crossref_config.yaml" -o $@

pdf: $(TEX_FILES)
	ptex2pdf -l -ot -kanji=utf8 main
	ptex2pdf -l -ot -kanji=utf8 main

clean:
	- rm -rf main.bbl main.aux main.bcf main.log main.dvi main.pdf main.run.xml	
	- rm -rf $(OUTDIR)

.PHONY:
	pdf clean
