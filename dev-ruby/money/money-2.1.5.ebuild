# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/zentest/zentest-3.3.0.ebuild,v 1.1 2006/08/28 14:34:06 pclouds Exp $

EAPI="2"
USE_RUBY="ruby18"

# Documentation uses hanna, but hanna is broken with newer versions of
# RDoc.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

inherit ruby-fakegem

DESCRIPTION="This library aids one in handling money and different currencies."
HOMEPAGE="http://money.rubyforge.org/"
LICENSE="MIT"

KEYWORDS="~amd64 ~ia64 ~x86"
SLOT="0"
IUSE=""
