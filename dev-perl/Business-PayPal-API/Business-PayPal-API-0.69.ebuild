# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="HEMBREED"
inherit perl-module

DESCRIPTION="PayPal API"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/SOAP-Lite"
RDEPEND="${DEPEND}"
SRC_TEST="do"