# add to PROJECTS variable all the projects to compile, without the .tex suffix
PROJECTS = changelog-llm

BUILDDIR = build
OUTPUT_IMAGESDIR = $(BUILDDIR)/images
DOCUMENTS = $(addprefix $(BUILDDIR)/,$(addsuffix .pdf,$(PROJECTS)))
SCREENSHOTS = $(addprefix $(OUTPUT_IMAGESDIR)/, $(patsubst %,%-screenshot,$(PROJECTS)))


all: documents screenshots

documents: $(DOCUMENTS)

$(BUILDDIR)/%.pdf: %.tex | $(BUILDDIR)
	lualatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $<
	lualatex -interaction=nonstopmode -output-directory=$(BUILDDIR) $<
	echo "#  Changelog LLM slides" > README.md
	echo >> README.md
	echo "Short introduction to automated changelog generation using fine-tuned T5 models" >> README.md
	echo >> README.md

screenshots:	$(SCREENSHOTS)

$(OUTPUT_IMAGESDIR)/%-screenshot: $(BUILDDIR)/%.pdf
	rm -fv $(OUTPUT_IMAGESDIR)/*.png
	gs -dBATCH -dNOPAUSE -dSAFER -r600 -sDEVICE=pngalpha -sOutputFile=$(OUTPUT_IMAGESDIR)/$*-%02d.png $<
	touch $@
	@for im in build/images/*.png; do \
		echo "![Screenshot]($$im)" >> README.md; \
		echo >> README.md; \
	done
	echo "([PDF]($<))" >> README.md

$(BUILDDIR):
	mkdir -p $(BUILDDIR) $(OUTPUT_IMAGESDIR)

clean:
	rm -f $(BUILDDIR)/{*.snm,*.out,*.toc,*.pdf,*.aux,*.log,*.nav,*.vrb} $(OUTPUT_IMAGESDIR)/*

.PHONY: all clean screenshots dir test
