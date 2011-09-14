# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib

# Maintainer notes: Take a look at http://xmlrpc-c.sourceforge.net/release.html
# We use "advanced" branch, so for the current release revision take look here:
# http://xmlrpc-c.svn.sourceforge.net/viewvc/xmlrpc-c/advanced/version.mk?view=log
# e.g. for 1.27.05 corresponds following revision 2182 and thus following URL:
# http://xmlrpc-c.svn.sourceforge.net/viewvc/xmlrpc-c/advanced.tar.gz?view=tar&pathrev=2182
# Note: autogenerated tarball checksum will change everytime, thus download it
# manually and distribute on mirrors.

DESCRIPTION="A lightweigt RPC library based on XML and HTTP"
HOMEPAGE="http://xmlrpc-c.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~pva/dist/xmlrpc-c-1.27.06.tar.gz"

KEYWORDS="~amd64"
IUSE="abyss +cgi +curl +cxx libxml2 libwww ssl static-libs threads tools"
LICENSE="BSD"
SLOT="0"

REQUIRED_USE="ssl? ( libwww )"

DEPEND="
	tools? ( dev-perl/frontier-rpc )
	curl? ( net-misc/curl )
	libwww? ( net-libs/libwww 
		ssl? ( net-libs/libwww[ssl] ) )
	libxml2? ( dev-libs/libxml2 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/advanced"

pkg_setup() {
	use curl || use libwww || \
		ewarn "Curl support disabled: No client library will be be built"
}

#Bug 214137: We need to filter this.
unset SRCDIR

# Bug 255440
export LC_ALL=C
export LANG=C

PATCHES=(
	"${FILESDIR}/${P}/dumpvalue.patch"
	"${FILESDIR}/${P}/cpp-depends.patch"
	"${FILESDIR}/${P}/dump-symlinks.patch"
	"${FILESDIR}/${P}/curl-headers.patch"
	)

src_prepare() {
#	base_src_prepare

	# DROPPED: Respect the user's CFLAGS/CXXFLAGS.
	sed -i \
		-e "/CFLAGS_COMMON/s|-g -O3$||" \
		-e "/CXXFLAGS_COMMON/s|-g$||" \
		"${S}"/common.mk || die "404. File not found while sedding"

	# Respect the user's LDFLAGS.
	export LADD=${LDFLAGS}

	use static-libs || { sed \
		-e '/\(^TARGET_STATIC_LIBRARIES =\)/{s:\(^TARGET_STATIC_LIBRARIES =\).*:\1:;P;N;d;}' \
			-i common.mk || die; }
}

src_configure() {
	econf --disable-wininet-client \
		$(use_enable libxml2 libxml2-backend) \
		$(use_enable libwww libwww-client) \
		$(use_enable ssl libwww-ssl) \
		$(use_enable tools) \
		$(use_enable threads abyss-threads) \
		$(use_enable cgi cgi-server) \
		$(use_enable abyss abyss-server) \
		$(use_enable cxx cplusplus) \
		$(use_enable curl curl-client)
}

src_compile() {
	emake -r
}

src_test() {
	if use abyss && use curl; then
		unset LDFLAGS LADD SRCDIR
		cd "${S}"/src/test/
		einfo "Building general tests"
		make || die "Make of general tests failed"
		einfo "Running general tests"
		./test || die "General tests failed"

		if use cxx; then
			cd "${S}"/src/cpp/test
			einfo "Building C++ tests"
			make || die "Make of C++ tests failed"
			einfo "Running C++ tests"
			./test || die "C++ tests failed"
		fi
	else
		elog "${CATEGORY}/${PN} tests will fail unless USE='abyss curl' is set."
	fi
}
