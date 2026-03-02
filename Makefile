.ONESHELL:
.PHONY: all n1 n2 n3 build clean

all: n1 n2 n3

n1:
	$(MAKE) build COURSE=cours-n1

n2:
	$(MAKE) build COURSE=cours-n2

n3:
	$(MAKE) build COURSE=cours-n3

build:
	@echo "Creating build directory for $(COURSE)..."
	mkdir -p build/$(COURSE)
	rsync -a src/$(COURSE)/ build/$(COURSE)/
	rsync -a src/common/ build/$(COURSE)/

	@echo "Changing directory to build/$(COURSE)/ ..."
	cd build/$(COURSE)

	@echo "Compiling LaTeX files ..."
	pdflatex --shell-escape main.tex
	pdflatex --shell-escape main.tex

	@echo "Copying output PDF to output directory ..."
	cd ../..
	mkdir -p output
	cp build/$(COURSE)/main.pdf output/$(COURSE).pdf
	@echo "Compiling subfile main.tex in slides subfolders ..."
	for subdir in build/$(COURSE)/slides/*/; do \
		subfolder=$$(basename $$subdir); \
		echo "Compiling $$subdir/$$subfolder.tex ..."; \
		if [ -f "$$subdir/$$subfolder.tex" ]; then \
			echo "Compiling $$subdir/$$subfolder.tex ..."; \
			(cd $$subdir && pdflatex --shell-escape $$subfolder.tex && pdflatex --shell-escape $$subfolder.tex); \
			mkdir -p output/$(COURSE); \
			cp build/$(COURSE)/slides/$$subfolder/$$subfolder.pdf output/$(COURSE)/$$subfolder.pdf; \
		fi; \
	done

clean:
	@echo "Cleaning build directory and output files"
	rm -rf build output *.pdf *.sha
