# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

SRC_VER="1.1.1"
inherit  perl-module

DESCRIPTION="Misc Utilities PERL Open-CA Extention"
SRC_URI="mirror://sourceforge/openca/openca-base-${SRC_VER}.tar.gz"
KEYWORDS="~amd64 ~x86"

IUSE=""
SLOT="0"

DEPEND=""
RDEPEND="dev-perl/XML-Twig"

S="${WORKDIR}/openca-base-${SRC_VER}/src/modules/openca-tools"

src_prepare() {
	perl-module_src_prepare
	einfo "editing MANIFEST"
	sed -i -e /prova.pl/d "${S}"/MANIFEST || die "sed failed"
	rm -f "${S}"/prova.pl
}
