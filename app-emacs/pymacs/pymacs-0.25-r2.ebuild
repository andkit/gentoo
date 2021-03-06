# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit elisp distutils-r1 vcs-snapshot

DESCRIPTION="A tool that allows both-side communication beetween Python and Emacs Lisp"
HOMEPAGE="https://www.emacswiki.org/emacs/PyMacs"
SRC_URI="https://github.com/pinard/Pymacs/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ia64 ppc ppc64 ~s390 ~sh x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc"

DEPEND="doc? (
		>=dev-python/docutils-0.7
		virtual/latex-base )
"
RDEPEND=""

DISTUTILS_IN_SOURCE_BUILD=1
SITEFILE="50${PN}-gentoo.el"

python_prepare_all() {
	sed \
		-e '/pymacs-python-command/s/@PYTHON@/python/' \
		-i pymacs.el.in || die
	distutils-r1_python_prepare_all
}

# called by distutils-r1 for every python implementation
python_configure() {
	# pre-process the files but don't run distutils
	emake PYSETUP=: PYTHON=${EPYTHON}
}

# called once
python_compile_all() {
	elisp_src_compile
	if use doc; then
		VARTEXFONTS="${T}"/fonts emake RST2LATEX=rst2latex.py pymacs.pdf
	fi
}

python_install_all() {
	elisp_src_install

	distutils-r1_python_install_all
	dodoc pymacs.rst
	use doc && dodoc pymacs.pdf
}
