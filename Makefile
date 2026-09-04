.ONESHELL:
.PHONY: all all-theorie all-pratique n1 n2 n3 p1 p2 p3 build clean

# theorie par défaut si TYPE n'est pas précisé
TYPE ?= theorie

# Racine du dépôt, pour retrouver resources/templates quel que soit le
# sous-répertoire de build dans lequel pdflatex est invoqué.
ROOT_DIR := $(CURDIR)

# Dossier des thèmes/styles partagés (sous-module git resources/templates/
# diving-beamer-template, ex: beamerthemeUnderwater.sty), ajouté à TEXINPUTS
# pour que tous les beamers puissent le trouver.
export TEXINPUTS := .:$(ROOT_DIR)/resources/templates/diving-beamer-template/src:

all-theorie: n1 n2 n3

all-pratique: p1 p2 p3

all: all-theorie all-pratique

n1:
	$(MAKE) build COURSE=cours-n1 TYPE=theorie

n2:
	$(MAKE) build COURSE=cours-n2 TYPE=theorie

n3:
	$(MAKE) build COURSE=cours-n3 TYPE=theorie

p1:
	$(MAKE) build COURSE=cours-n1 TYPE=pratique

p2:
	$(MAKE) build COURSE=cours-n2 TYPE=pratique

p3:
	$(MAKE) build COURSE=cours-n3 TYPE=pratique

build:
	@echo "Creating build directory for $(TYPE)/$(COURSE)..."
	mkdir -p build/$(TYPE)/$(COURSE)
	rsync -a src/$(TYPE)/$(COURSE)/ build/$(TYPE)/$(COURSE)/
	rsync -a src/$(TYPE)/common/ build/$(TYPE)/$(COURSE)/

	@echo "Changing directory to build/$(TYPE)/$(COURSE)/ ..."
	cd build/$(TYPE)/$(COURSE)

	@echo "Compiling LaTeX files ..."
	pdflatex --shell-escape main.tex
	pdflatex --shell-escape main.tex

	@echo "Copying output PDF to output directory ..."
	cd ../../..
	mkdir -p output/$(TYPE)
	cp build/$(TYPE)/$(COURSE)/main.pdf output/$(TYPE)/$(COURSE).pdf
	@echo "Compiling subfile main.tex in slides subfolders ..."
	for subdir in build/$(TYPE)/$(COURSE)/slides/*/; do \
		subfolder=$$(basename $$subdir); \
		echo "Compiling $$subdir/$$subfolder.tex ..."; \
		if [ -f "$$subdir/$$subfolder.tex" ]; then \
			echo "Compiling $$subdir/$$subfolder.tex ..."; \
			(cd $$subdir && pdflatex --shell-escape $$subfolder.tex && pdflatex --shell-escape $$subfolder.tex); \
			mkdir -p output/$(TYPE)/$(COURSE); \
			cp build/$(TYPE)/$(COURSE)/slides/$$subfolder/$$subfolder.pdf output/$(TYPE)/$(COURSE)/$$subfolder.pdf; \
		fi; \
	done

clean:
	@echo "Cleaning build directory and output files"
	rm -rf build output *.pdf *.sha