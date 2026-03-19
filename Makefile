SOURCE := forth-cheat-sheet.md
STYLE := print.css
TEMPLATE := template.html
OUTDIR := output
VERSION := $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
RENDERED := $(OUTDIR)/forth-cheat-sheet.rendered.md
HTML := $(OUTDIR)/forth-cheat-sheet.html
PDF := $(OUTDIR)/forth-cheat-sheet.pdf

.PHONY: all html pdf clean

all: pdf

html: $(HTML)

pdf: $(PDF)

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(RENDERED): $(SOURCE) | $(OUTDIR)
	sed 's/@VERSION@/$(VERSION)/g' $(SOURCE) > $(RENDERED)

$(HTML): $(RENDERED) $(STYLE) $(TEMPLATE)
	pandoc $(RENDERED) -f gfm -t html5 -s --metadata title="Forth Cheat Sheet" --template=$(TEMPLATE) -c ../$(STYLE) -o $(HTML)

$(PDF): $(HTML)
	weasyprint $(HTML) $(PDF)

clean:
	rm -rf $(OUTDIR)
