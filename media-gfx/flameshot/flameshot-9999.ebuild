# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 qmake-utils xdg

DESCRIPTION="Powerful yet simple to use screenshot software for GNU/Linux"
HOMEPAGE="https://flameshot.js.org"
EGIT_REPO_URI="https://github.com/lupoDharkael/${PN}.git"

LICENSE="FreeArt GPL-3+ Apache-2.0"
SLOT="0"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtsvg:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}"

src_configure() {
	export INSTALL_ROOT="${D}"
	eqmake5 CONFIG+=packaging

	elog "Read https://github.com/lupoDharkael/flameshot#global for runtime configuration"
}
