# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit mercurial python

SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 3.* *-jython"

DESCRIPTION="Autopager extension for Mercurial SCM"
HOMEPAGE="http://mercurial.selenic.com/wiki/AutopagerExtension"
SRC_URI=""

EHG_REPO_URI="https://skrattaren@bitbucket.org/brodie/autopager"

LICENSE="as-is"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="<dev-vcs/mercurial-1.9"
RDEPEND="${DEPEND}"

src_prepare() {
	rm LICENSE.txt
	python_copy_sources
}

src_install() {
	dumb_install() {
		insinto $(python_get_sitedir)
		doins autopager.py
	}
	python_execute_function dumb_install
}
