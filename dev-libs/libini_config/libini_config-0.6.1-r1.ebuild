# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Ini_config library from sssd projects"
HOMEPAGE="https://fedorahosted.org/sssd/wiki/"
SRC_URI="https://fedorahosted.org/released/ding-libs/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="trace doc"

RDEPEND=">=dev-libs/libcollection-0.5.0
	>=dev-libs/libpath_utils-0.2.0
	>=dev-libs/libref_array-0.1.0
	!dev-libs/ding-libs"

DEPEND="doc? ( app-doc/doxygen )
	${RDEPEND}"

src_configure() {
	econf \
		$(use trace && echo '--enable-trace=7') || die
}

src_install() {
	emake DESTDIR="${ED}" install || die
}