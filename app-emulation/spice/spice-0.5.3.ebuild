# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
WANT_AUTOMAKE="1.10"

inherit autotools

DESCRIPTION="Provide high-quality remote access to QEMU using SPICE protocol"
HOMEPAGE="http://www.spice-space.org http://www.redhat.com/virtualization/rhev"
SRC_URI="http://www.spice-space.org/download/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="proxy gui opengl"

COMMON_DEP=">=x11-libs/pixman-0.17
	>=x11-apps/xrandr-1.2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/cairo[X,opengl]
	dev-libs/log4cpp
	media-libs/celt:5
	media-video/ffmpeg[jpeg2k]
	media-libs/alsa-lib
	dev-libs/openssl
	virtual/glu
	virtual/jpeg
	>=sys-devel/gcc-4.1
	app-emulation/spice-protocol
	gui? ( =dev-games/cegui-6* )
	proxy? ( net-dialup/slirp )"
DEPEND="${COMMON_DEP}
	dev-util/pkgconfig
	sys-devel/libtool"

RDEPEND="${COMMON_DEP}"

src_prepare() {
	#disable uneede pyton check
	epatch "${FILESDIR}/"disable-python-check-configure.ac.patch || die
	sed -i -e 's/python_modules/ /g' Makefile.am || die "sed failed"

	eautoreconf
}

src_configure() {
	local myconf=""

	if use proxy;then
		myconf+=" --enable-tunnel "
	fi
	if use gui; then
		myconf+="  --enable-gui "
	fi

	econf \
		${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failded"
	dodoc AUTHORS ChangeLog NEWS README

	find "${D}" -name '*.la' -delete
}
