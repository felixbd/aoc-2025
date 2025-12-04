
w:
	typst w main.typ

c:
	typst c --pdf-standard a-3b main.typ

o:
	xdg-open main.pdf

r:
	rm -fr main.pdf
