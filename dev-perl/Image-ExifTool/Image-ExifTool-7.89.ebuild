# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MODULE_AUTHOR="EXIFTOOL"
inherit perl-module

DESCRIPTION="Read and write meta information  in EXIF image format"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
SRC_TEST="do parallel"
