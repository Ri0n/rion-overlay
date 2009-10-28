# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.9"
inherit rpm autotools

DESCRIPTION="Dog-Tag Certificate System: Native Command Line Utilities"
HOMEPAGE="http://pki.fedoraproject.org/wiki/PKI_Documentation"
SRC_URI="http://pki.fedoraproject.org/pki/download/pki/1.2.0/fc11/SRPMS/pki-native-tools-1.2.0-2.fc11.src.rpm"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug"

DEPEND="dev-libs/cyrus-sasl
		dev-libs/mozldap
		dev-libs/nspr
		dev-libs/nss
		dev-libs/svrcore"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PV}/"gentoo-filesystems-layount.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable amd64 64bit) \
		$(use_enable debug) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
