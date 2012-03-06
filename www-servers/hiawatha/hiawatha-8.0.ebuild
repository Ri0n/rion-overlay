# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

CMAKE_MIN_VERSION="2.8.4"

inherit cmake-utils

DESCRIPTION="Advanced and secure webserver"
HOMEPAGE="http://www.hiawatha-webserver.org"
SRC_URI="http://www.hiawatha-webserver.org/files/${P}.tar.gz
	monitor? ( http://www.hiawatha-webserver.org/files/monitor-0.3.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +cache chroot +command ipv6 monitor ssl toolkit xslt"

DEPEND="ssl?  ( net-libs/polarssl )
	 	xslt? ( dev-libs/libxslt
	 		dev-libs/libxml2 )
		monitor? ( 	virtual/cron
					=dev-lang/php-5*[mysql]
					virtual/mysql )
		"

RDEPEND="${DEPEND}"

REQUIRED_USE="monitor? ( xslt )"
# monitor and xslt depend own

PATCHES=("${FILESDIR}"/cmake_disable_bundled.patch)

src_unpack() {
	unpack ${P}.tar.gz

	if use monitor; then
		mkdir "${WORKDIR}"/monitor
		unpack monitor-0.3.tar.gz
	fi
}

src_configure() {
	if use debug; then
		CMAKE_BUILD_TYPE="RelWithDebInfo"
	else
		CMAKE_BUILD_TYPE="Gentoo"
	fi

	mycmakeargs=(
		$(cmake-utils_use_enable cache CACHE)
		$(cmake-utils_use_enable chroot CHROOT)
		$(cmake-utils_use_enable command COMMAND)
		$(cmake-utils_use_enable ipv6 IPV6)
		$(cmake-utils_use_enable debug DEBUG)
		$(cmake-utils_use_enable monitor MONITOR)
		$(cmake-utils_use_enable ssl SSL)
		$(cmake-utils_use_enable toolkit TOOLKIT)
		$(cmake-utils_use_enable xslt XSLT)
		-DLOG_DIR:STRING=/var/log/hiawatha
		-DPID_DIR:STRING=/var/run
		-DWEBROOT_DIR:STRING=/var/www/hiawatha
		-DWORK_DIR:STRING=/var/lib/hiawatha
		-DCONFIG_DIR:STRING=/etc/hiawatha
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/hiawatha.init  hiawatha
	newinitd "${FILESDIR}"/php-fcgi_hiawatha.init  hiawatha_php-fcgi

	keepdir /var/l{ib,og}/hiawatha

	insinto /usr/share/"${PN}"/monitor
	doins -r "${WORKDIR}"/monitor/*
	newdoc "${WORKDIR}"/monitor/README README.monitor
	newdoc "${WORKDIR}"/monitor/ChangeLog ChangeLog.monitor
}

pkg_postinst() {
	if use monitor; then
		einfo "You request serwer monitor feature"
		einfo "required files install in ${ED}/usr/share/"${PN}"/monitor"
		einfo "Please read Monitor HOWTOO "
		einfo "from http://www.hiawatha-webserver.org/howto/monitor"
		einfo "and configure you virtual serwer - i.e add "
		einfo " required string in config files, setup mysql databases"
		einfo "and add cron  job"
	fi
}