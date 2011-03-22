# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Author: mva $
EAPI="3"

inherit eutils

DESCRIPTION="Asterisk's russian sounds. \"Tamara\" pack."
HOMEPAGE="http://asteriskforum.ru/"
SRC_URI="ftp://ftp.dvgu.ru/pub/Network/VoIP/SIP/Asterisk/Russian-Tamara-2.0.2-ulaw.tar.gz"

KEYWORDS="~x86 ~amd64"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=net-misc/asterisk-1.6.2.0"

src_unpack() {
	unpack "./Russian-Tamara-2.0.2-ulaw/sounds.tar.gz"
}

src_install() {
	insinto /var/lib/asterisk/sounds
	doins -r sounds/*
}