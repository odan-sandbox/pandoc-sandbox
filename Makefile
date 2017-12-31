# ここにpdf化したいmarkdownが含まれるディレクトリを指定してください
MD_DIRS:=intro odan code_test

# 以下触らないこと
OUTDIR:=build
TEX_FILES:=$(foreach dir, $(MD_DIRS), $(OUTDIR)/$(dir).tex)
HTML_FILES:=$(foreach dir, $(MD_DIRS), $(OUTDIR)/$(dir).html)
TARGET:=main.pdf


PWD=$(shell pwd)
NB_UID=$(shell id -u)
NB_GID=$(shell id -g)

define RUN
	docker-compose run --user=root --rm -v $(PWD):/home/user/work -e NB_UID=$(NB_UID) -e NB_GID=$(NB_GID) $1 $2
endef

GET_DIR_NAME=$(patsubst %/,%,$(word 1, $(dir $1)))

all: tex html pdf

docker-build:
	docker-compose build base
	docker-compose build pandoc texlive

docker-pull:
	docker-compose pull

$(OUTDIR)/%.tex: %/*
	mkdir -p $(OUTDIR)
	$(eval DIR_NAME=$(call GET_DIR_NAME,$^))

	$(eval MD_FILES=$(sort $(wildcard $(DIR_NAME)/*.md)))

	$(eval BIB_FILE=$(DIR_NAME)/$(DIR_NAME).bib)
	$(eval CITE_OPTION=$(shell if [ -f $(BIB_FILE) ]; then echo --bibliography=$(BIB_FILE); else echo ; fi))

	$(call RUN, pandoc, pandoc $(MD_FILES) $(CITE_OPTION) --filter pandoc-crossref -M "crossrefYaml=crossref_config.yaml" -o $@)

tex: $(TEX_FILES)

pdf: $(TEX_FILES)
	$(call RUN, texlive, ptex2pdf -l -ot -kanji=utf8 main)
	$(call RUN, texlive, ptex2pdf -l -ot -kanji=utf8 main)


$(OUTDIR)/%.html: %/*
	mkdir -p $(OUTDIR)
	$(eval DIR_NAME=$(call GET_DIR_NAME,$^))

	$(eval MD_FILES=$(sort $(wildcard $(DIR_NAME)/*.md)))

	$(eval BIB_FILE=$(DIR_NAME)/$(DIR_NAME).bib)
	$(eval CITE_OPTION=$(shell if [ -f $(BIB_FILE) ]; then echo --bibliography=$(BIB_FILE); else echo ; fi))

	$(call RUN, pandoc, pandoc $(MD_FILES) $(CITE_OPTION) --filter pandoc-crossref -M "crossrefYaml=crossref_config.yaml" -o $@)

html: $(HTML_FILES)

clean:
	- rm -rf main.bbl main.aux main.blg main.bcf main.log main.dvi main.pdf main.run.xml	
	- rm -rf $(TARGET)
	- rm -rf $(OUTDIR)

.PHONY:
	all docker-build docker-pull pdf html clean
