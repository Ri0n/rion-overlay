# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit leechcraft

DESCRIPTION="DBusManager provides some basic D-Bus interoperability for LeechCraft."

SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="=net-misc/leechcraft-core-${PV}
		>=x11-libs/qt-dbus-4.6"
RDEPEND="${DEPEND}"
