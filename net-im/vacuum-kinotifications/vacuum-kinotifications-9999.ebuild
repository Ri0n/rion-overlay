# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

LANGS="ru"

inherit cmake-utils mercurial

MY_PN="${PN/vacuum-/}"
DESCRIPTION="Kinetic popup notifications for vacuum"
HOMEPAGE="http://code.google.com/p/vacuum-im"
EHG_REPO_URI="https://code.google.com/p/vacuum-plugins.${MY_PN}/"
EHG_REVISION="${MY_PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

RDEPEND="
	>=net-im/vacuum-1.1.0
	x11-libs/qt-webkit:4
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/hg"

src_configure() {
	# linguas
	local langs="none;"
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x};"
	done

	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DLANGS="${langs}"
	)

	cmake-utils_src_configure
}
