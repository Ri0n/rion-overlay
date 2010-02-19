# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.6"

inherit autotools apache-module flag-o-matic

DESCRIPTION="SSL/TLS module for the Apache HTTP server"
HOMEPAGE="http://directory.fedoraproject.org/wiki/Mod_nss"
SRC_URI="http://directory.fedoraproject.org/sources/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ecc"

DEPEND=">=dev-libs/nss-3.11.4
		>=dev-libs/nspr-4.6.4
		dev-util/pkgconfig"

RDEPEND=">=dev-libs/nss-3.11.4
		>=dev-libs/nspr-4.6.4"

APACHE2_MOD_CONF="47_${PN}"
APACHE2_MOD_DEFINE="NSS"

DOCFILES="NOTICE README "

need_apache2

src_prepare() {
	# add gentoo naming
	sed -i -e 's/certutil/nsscertutil/' gencert.in || die "sed failed"

	eautoreconf
}

src_configure() {
	# for future added all (linux)  64 but flags
	setup-allowed-flags
	filter-flag  -O3
	use amd64  && append-cflags -m64

	econf \
	$(use_enable ecc) \
	--with-apxs=${APXS} || die "econf failed"

}

src_compile() {
	emake || die
}
src_install() {
	mv .libs/libmodnss.so .libs/"${PN}".so || die

	dosbin gencert nss_pcache
	dohtml docs/mod_nss.html
	newbin migrate.pl nss_migrate
	dodir /etc/apache2/nss

	apache-module_src_install
}
pkg_postinst() {
	apache-module_pkg_postinst

	elog "If you have create self-signed"
	elog "certificate, plz. install"
	elog "net-dns/bind-tools packages and"
	elog "use gencert script"
	elog ""
	elog "For intro NSS library read READMI files and web page:"
	elog "http://www.mozilla.org/projects/security/pki/nss/"
	elog ""
	elog "For intro mod_nss read READMI files and web page:"
	elog "http://directory.fedoraproject.org/docs/mod_nss.html"
}

#TODO generating self-signed certs.
#pkg_config() {

#: ;
# gencert /etc/apache2/nss
#}
