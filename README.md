# Cours Plongée LaTeX Build System

This project uses Makefiles to automate the compilation of LaTeX documents for diving courses.

## Prerequisites

To build the LaTeX documents on Linux, you need the following tools installed:

- **Make**: A build automation tool. Install with `sudo apt-get install make` (on Debian/Ubuntu) or equivalent for your distribution.
- **pdflatex**: Part of the TeX Live distribution for compiling LaTeX to PDF. Install with `sudo apt-get install texlive-latex-base texlive-latex-extra` or the full TeX Live package.
- **rsync**: For copying files. Usually pre-installed on Linux; if not, `sudo apt-get install rsync`.

Ensure you have the necessary LaTeX packages for your documents (e.g., if using specific packages, install them via `tlmgr` or your package manager).

## Usage

The Makefile supports building specific courses. Currently, it includes:

- `n1`: Builds the `cours-n1` course.
- `n3`: Builds the `cours-n3` course.
- `all`: Builds all available courses.

To build a specific course, run:

```bash
make n1
# or
make n3
# or
make all
```
