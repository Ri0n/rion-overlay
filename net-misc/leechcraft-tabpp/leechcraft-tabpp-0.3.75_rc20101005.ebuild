# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="Tab++ provides enhanced tab-related features like tab tree for LeechCraft."

IUSE="debug"
DEPEND="=net-misc/leechcraft-core-${PV}"
RDEPEND="${DEPEND}"
KEYWORDS="~amd64 ~x86"
