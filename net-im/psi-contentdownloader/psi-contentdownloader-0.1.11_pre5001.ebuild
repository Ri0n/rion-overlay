# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit psiplus-plugin

DESCRIPTION="Psi plugin for downloading extras"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="net-libs/libproxy"
RDEPEND="${DEPEND}"