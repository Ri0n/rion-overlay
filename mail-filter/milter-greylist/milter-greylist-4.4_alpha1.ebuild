# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit base  eutils confutils

MY_PV="4.4a1"
DESCRIPTION="Milter-greylist is a stand-alone milter that implements the greylist filtering method"
HOMEPAGE="http://hcpnet.free.fr/milter-greylist"
SRC_URI="ftp://ftp.espci.fr/pub/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 bind +ssl ldap geoip spf dkim drac-p +p0f spamassassin sendmail dnsrbl postfix curl"

CDEPEND="net-mail/mailbase
	sendmail? (
		mail-mta/sendmail
		!!mail-filter/libmilter
		dkim? (
			mail-filter/libdkim
			)
			)
	<sys-libs/db-5.0.0
	p0f? ( net-analyzer/p0f )
	bind? ( net-dns/bind[ipv6?] )
	ssl? ( dev-libs/openssl )
	ldap? ( net-nds/openldap[ipv6?] )
	curl? ( net-misc/curl[ipv6?] )
	geoip? ( dev-libs/geoip )
	spf? ( mail-filter/libspf2 )
	postfix? (
				>=mail-mta/postfix-2.5[ipv6?]
				mail-filter/libmilter[ipv6?]
				)
	drac-p? ( mail-client/drac )
	spamassassin? ( mail-filter/spamassassin[ipv6,ldap?] )
	"
DEPEND="sys-devel/flex
	sys-devel/bison
	dev-util/pkgconfig
	${CDEPEND}
	"

RDEPEND="${CDEPEND}"

pkg_pretend() {
	confutils_require_one postfix sendmail
	confutils_use_conflict postfix sendmail
	confutils_use_conflict sendmail postfix
	confutils_use_conflict postfix dkim
}

pkg_setup() {
	if use postfix ;then
		einfo "Checking for postfix group ..."
		enewgroup postfix 207 || die "problem adding group postfix"

		einfo "Checking for postdrop group ..."
		enewgroup postdrop 208 || die "problem adding group postdrop"

		einfo "Checking for postfix user ..."
		enewuser postfix 207 -1 /var/spool/postfix postfix,mail \
				|| die "problem adding user postfix"
	else

		einfo "checking for smmsp group...    create if missing."
		enewgroup smmsp 209 || die "problem adding group smmsp"

		einfo "checking for smmsp user...     create if missing."
		enewuser smmsp 209 -1 /var/spool/mqueue smmsp \
		 || die "problem adding user smmsp"
	fi
}

src_prepare() {

	sed  -e "/CONFFILE/s/greylist.conf/greylist2.conf/" -i Makefile.in \
								|| die "sed makefile failed"
	elog "Makefile fixed "

	if use drac; then
		sed -i -e  \
			's|"/usr/local/etc/drac.db/"|"/var/lib/drac/drac.db"|' \
	 									greylist2.conf || die "sed drac failed"
	else

		sed -i -e 's/#nodrac/nodrac/' greylist2.conf || die "sed nodrac failed"
	fi

	if use postfix; then
		sed -e 's/#user\ "smmsp"/user\ "postfix"/' -i greylist2.conf \
											|| die "add postfix user failed"
	fi

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
		-i greylist2.conf || die "socket fix failed"

sed -e 's|"/var/milter-greylist/milter-greylist.sock"|"/var/run/milter-greylist/milter-greylist.sock"|'\
	-i milter-greylist.m4 || die "sed in milter-greylist.m4 failed"

sed -e 's|"/var/milter-greylist/greylist.db"|"/var/lib/db/milter-greylist/greylist.db"|'\
					-i greylist2.conf || die "fix db file location  failed"

	ecvs_clean
}

src_configure() {
	local myconf=""

	if use postfix ;then
		myconf+="--with-user=postfix "
	else
		myconf+="--with-user=smmsp "
	fi
	use bind	&& myconf+=" --with-libbind"
	use spf		&& myconf+=" --with-libspf2"
	use dkim	&& myconf+=" --with-libdkim"
	use geoip	&& myconf+=" --with-libGeoIP"
	use ssl		&& myconf+=" --with-openssl"
	use ldap	&& myconf+=" --with-openldap"
	use curl	&& myconf+=" --with-libcurl"

	econf \
		--with-db \
		--enable-mx \
		--disable-rpath \
		--with-libmilter \
		--with-conffile="/etc/mail/${PN}.conf" \
		--with-dumpfile="/var/lib/${PN}/${PN}.db" \
		--with-thread-safe-resolver \
		$(use_enable drac-p drac) \
		$(use_enable p0f) \
		$(use_enable spamassassin) \
		$(use_enable dnsrbl) \
		$(use_enable postfix) \
		${myconf} || die "myconf failed"
}

src_install() {

	emake DESTDIR="${ED}" install || die "install failed"

	if use !postfix;then
		insinto /usr/share/sendmail-cf/hack/
		doins milter-greylist.m4
	fi

	dodoc ChangeLog README milter-greylist.m4

	newinitd "${FILESDIR}"/gentoo.initd milter-greylist
	newconfd  "${FILESDIR}"/gentoo.confd milter-greylist

	if use postfix;then
		echo "USER=postfix" >> "${ED}"/etc/conf.d/milter-greylist || die
	else
		echo "USER=smmsp" >> "${ED}"/etc/conf.d/milter-greylist || die
	fi

	local user="smmsp"
	use postfix && user="postfix"

	diropts -m750 --owner=$user
	dodir /var/run/milter-greylist/

	diropts -m770 --owner=$user
	dodir /var/lib/milter-greylist/
	keepdir /var/lib/milter-greylist/
}

pkg_postinst() {
	if [  -e "${EROOT}"/var/lib/milter-greylist/greylist.db ] ; then
		touch "${EROOT}"/var/lib/milter-greylist/greylist.db || die
	fi

	if use !postfix; then
		elog
		elog " You can enable milter-greylist in your sendmail, adding the line: "
		elog " HACK(\`milter-greylist')dnl"
		elog " to you sendmail.mc file"
		elog
	fi

	if use postfix;then
		chown postfix "${EROOT}"/var/lib/milter-greylist/greylist.db

		elog
		elog " You can enable milter-greylist in your postfix, adding the line:"
		elog " smtpd_milters = unix:/var/run/milter-greylist/milter-greylist.sock "
		elog " milter_connect_macros = j "
		elog " and "
		elog " milter_default_action = accept "
		elog " to /etc/postfix/main.cf file"
		elog
	fi

	elog "Config  files for milter-greylist /etc/milter-greylist/milter-greylist.conf"
	elog "Please edit it - default config not works and bad."
}
