# forth-cheat-sheet

Compact Forth cheat sheet in Markdown, intended for printing as a tri-fold reference.

You can download the [Forth Cheat Sheet as PDF](../../releases/latest/download/forth-cheat-sheet.pdf).

For printing, use double-sided output and flip on the short edge.

## Improving and creating the  PDF

Recommended on Ubuntu 24.04: `pandoc` + `weasyprint`.

The main source is [forth-cheat-sheet.md](forth-cheat-sheet.md). Print styling lives in [print.css](print.css). The Pandoc HTML template used for PDF generation lives in [template.html](template.html).

Install:

```bash
sudo apt install pandoc weasyprint
```

Build everything:

```bash
make pdf
```

This writes generated files to [output/](output/):

- [output/forth-cheat-sheet.html](output/forth-cheat-sheet.html)
- [output/forth-cheat-sheet.pdf](output/forth-cheat-sheet.pdf)

Other targets:

```bash
make html
make clean
```

## Guidelines

- Keep it compact. Prefer reference material over tutorial prose.
- Do not explain words whose meaning is already obvious from the name, such as `<`, `invert`, or `min`.
- Group operators by arity first: binary and unary.
- Within binary and unary, group operators by category: arithmetic, comparison, bit twiddling.
- Put related words on one line when they share the same stack effect.
- Use individual code spans for each word so lines wrap cleanly.
- Add short descriptions only where they add real information.
- Separate out operators with genuinely different stack effects, such as `um*` and `um/mod`.
- Write stack effects in italics using underscores: `_( a b -- c )_`
- Avoid bullet lists for dense operator sections when a compact line is clearer.
- Prefer a layout that works well in narrow columns for print.
- Keep examples minimal and focused.
