# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

WANT_PYTHON="2:2.6"

inherit  distutils

DESCRIPTION="Cache-friendly asset management via content-hash-naming"
HOMEPAGE="http://jderose.fedorapeople.org/assets"
SRC_URI="http://jderose.fedorapeople.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/nose"
RDEPEND="${DEPEND}"
DOCS="README TODO AUTHORS"
