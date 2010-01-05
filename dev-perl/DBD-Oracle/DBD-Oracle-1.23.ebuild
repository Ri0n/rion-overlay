# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=PYTHIAN
inherit perl-module eutils

DESCRIPTION="The Perl DBI Module for Oracle database"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-perl/DBI
		>=dev-db/oracle-instantclient-sqlplus-10.0"
RDEPEND="${DEPEND}"
