# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

WANT_AUTOMAKE="1.9"
MY_P=${P/_rc/.rc}
inherit eutils multilib flag-o-matic autotools

DESCRIPTION="389 Directory Server (core librares  and daemons )"
HOMEPAGE="http://port389.org/"
SRC_URI="http://directory.fedoraproject.org/sources/${MY_P}.tar.bz2"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="autobind auto-dn-suffix debug doc +pam-passthru +dna +ldapi +bitwise presence kerberos selinux"

ALL_DEPEND="dev-libs/nss[utils]
			dev-libs/nspr
			dev-libs/svrcore
			dev-libs/mozldap
			>=dev-libs/cyrus-sasl-2.1.19[kerberos?]
			>=dev-libs/icu-3.4
			>=sys-libs/db-4.5
			>=net-analyzer/net-snmp-5.1.2
			dev-libs/openssl
			sys-apps/tcp-wrappers
			sys-libs/pam
			sys-libs/zlib
			dev-perl/perl-mozldap
			dev-libs/libpcre:3
			kerberos? ( net-nds/openldap
					>=app-crypt/mit-krb5-1.7-r100[ldap]
					)
			selinux? ( >=sys-apps/policycoreutils-1.30.30
					sec-policy/selinux-base-policy
					)"

DEPEND="${ALL_DEPEND}
			dev-util/pkgconfig
			sys-devel/libtool:1.5
			doc? ( app-doc/doxygen )
			selinux? ( sys-devel/m4
						>=sys-apps/checkpolicy-1.30.12 )
			"
RDEPEND="${ALL_DEPEND}
			virtual/perl-Time-Local
			virtual/perl-MIME-Base64"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup dirsrv
	enewuser dirsrv -1 -1 -1 dirsrv
}

src_prepare() {
	sed -i -e 's/nobody/dirsrv/g' configure.ac

	use selinux && epatch "${FILESDIR}/1.2.6"/*selinux*.patch

	eautoreconf
}

src_configure() {
	local myconf=""

	use auto-dn-suffix && myconf+="--enable-auto-dn-suffix "
	use selinux && myconf+="--with-selinux "

	econf \
			$(use_enable debug) \
			$(use_enable pam-passthru) \
			$(use_enable ldapi) \
			$(use_enable autobind) \
			$(use_enable dna) \
			$(use_enable bitwise) \
			$(use_enable presence) \
			$(use_with kerberos) \
			--enable-maintainer-mode \
			--enable-autobind \
			--with-fhs \
			$myconf || die "econf failed"

}

src_compile() {
	append-lfs-flags

	emake || die "compile failed"
	if use selinux; then
		emake -f selinux/Makefile || die " build selinux policy failed"
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use selinux;then
		emake -f selinux/Makefile DESTDIR="${D}" install || die "Install selinux policy failed"
	fi

	# install not installed header
	insinto /usr/include/dirsrv
	doins ldap/servers/slapd/slapi-plugin.h

	# for build free-ipa require winsync-plugin
	doins ldap/servers/plugins/replication/winsync-plugin.h

	# make sure perl scripts have a proper shebang
	cd "${D}"/usr/share/dirsrv/script-templates/

	for i in $(find ./  -iname '*.pl') ;do
		sed -i -e 's/#{{PERL-EXEC}}/#\!\/usr\/bin\/perl/' $i || die
	done

	# remove redhat style init script
	rm -rf "${D}"/etc/rc.d || die
	rm -rf "${D}"/etc/default || die

	# and install gentoo style init script
	newinitd "${FILESDIR}"/dirsrv.initd dirsrv
	newinitd "${FILESDIR}"/dirsrv-snmp.initd dirsrv-snmp

	newconfd "${FILESDIR}"/dirsrv.confd dirsrv

	# cope with libraries being in /usr/lib/dirsrv
	dodir /etc/env.d
	echo "LDPATH=/usr/$(get_libdir)/dirsrv" > "${D}"/etc/env.d/08dirsrv

	# create the directory where our log file and database
	diropts -m 0750 -o dirsrv -g dirsrv
	keepdir /var/lib/dirsrv
	dodir /var/lock/dirsrv

	if use doc; then
		cd "${S}"
		doxygen slapi.doxy
		dohtml -r docs/html
	fi

	# net-snmp ebuild not create required directory
	# This dir. required for ldap snmp agent
	dodir /var/agentx
	keepdir /var/agentx/
}
pkg_postinst() {
if use selinux;then
	if has "loadpolicy" $FEATURES ; then
		einfo "Inserting the following modules into the  module store"
		cd /usr/share/selinux/targeted # struct policy not supported
		semodule -s dirsrv -i dirsrv.pp
	else
		echo
		echo
		eerror "Policy has not been loaded.  It is strongly suggested"
		eerror "that the policy be loaded before continuing!!"
		echo
		einfo "Automatic policy loading can be enabled by adding"
		einfo "\"loadpolicy\" to the FEATURES in make.conf."
		echo
		echo
		ebeep 4
		epause 4
	fi

fi
}
