SOURCE := forth-cheat-sheet.md
STYLE := print.css
TEMPLATE := template.html
OUTDIR := output
HTML := $(OUTDIR)/forth-cheat-sheet.html
PDF := $(OUTDIR)/forth-cheat-sheet.pdf

.PHONY: all html pdf clean

all: pdf

html: $(HTML)

pdf: $(PDF)

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(HTML): $(SOURCE) $(STYLE) $(TEMPLATE) | $(OUTDIR)
	pandoc $(SOURCE) -f gfm -t html5 -s --metadata title="Forth Cheat Sheet" --template=$(TEMPLATE) -c ../$(STYLE) -o $(HTML)

$(PDF): $(HTML)
	weasyprint $(HTML) $(PDF)

clean:
	rm -rf $(OUTDIR)
