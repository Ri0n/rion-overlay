# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit qt4-r2

DESCRIPTION="Vector metro (subway) map for calculating route and getting information about transport nodes."
HOMEPAGE="http://sourceforge.net/projects/qmetro/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-libs/qt-gui:4
"
DEPEND="${RDEPEND}
	app-arch/unzip
	virtual/libiconv
"

DOCS="AUTHORS README"

src_prepare() {
	default

	iconv -f cp1251 -t utf8 rc/qmetro.desktop -o rc/qmetro.desktop || die
}
