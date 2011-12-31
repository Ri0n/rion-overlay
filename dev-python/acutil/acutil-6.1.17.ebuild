# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.6"

inherit python

DESCRIPTION="Tool for setting up authentication from network services ( Python2 library )"
HOMEPAGE="http://fedoraproject.org/wiki/SystemConfig/"
SRC_URI="https://fedorahosted.org/releases/a/u/authconfig/authconfig-${PV}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RDEPEND="dev-perl/XML-Parser
	dev-libs/popt
	dev-libs/newt"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"

S="${WORKDIR}"/authconfig-"${PV}"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	insinto /$(python_get_sitedir)
	doins "${S}"/.libs/acutil*.so
}

pkg_postinst() {
	python_need_rebuild
}
