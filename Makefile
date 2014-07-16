COLLECTD_PREFIX?=/usr/local
COLLECTD_VERSION=5.4.0

COLLECTD_SRC=work/collectd-$(COLLECTD_VERSION)

LIBTOOL=$(COLLECTD_SRC)/libtool
FETCH=fetch

CFLAGS?=-DNDEBUG -O3

all: .INIT write_istatd.la

install: all
	$(LIBTOOL) --mode=install /usr/bin/install -c write_istatd.la \
		$(COLLECTD_PREFIX)/lib/collectd
	$(LIBTOOL) --finish \
		$(COLLECTD_PREFIX)/lib/collectd

clean:
	rm -rf .libs
	rm -rf build
	rm -f write_istatd.la

distclean: clean
	rm -rf work

.INIT:
	mkdir -p build
	mkdir -p work
	( if [ ! -d $(COLLECTD_SRC)/src ] ; then \
		if which fetch ; then \
			DOWNLOAD_TOOL=`which fetch` ; \
		elif which wget ; then \
			DOWNLOAD_TOOL=`which wget` ; \
		fi ; \
		cd work ; \
		$${DOWNLOAD_TOOL} http://collectd.org/files/collectd-$(COLLECTD_VERSION).tar.gz ; \
		tar zxvf collectd-$(COLLECTD_VERSION).tar.gz ; \
		cd collectd-$(COLLECTD_VERSION) ; \
		if [ ! -f libtool ] ; then \
			./configure ; \
		fi ; \
	fi )

write_istatd.la: build/write_istatd.lo
	$(LIBTOOL) --tag=CC --mode=link gcc -Wall -Werror $(CFLAGS) -module \
		-avoid-version -o $@ -rpath $(COLLECTD_PREFIX)/lib/collectd \
		-lpthread build/write_istatd.lo

build/write_istatd.lo: src/write_istatd.c
	$(LIBTOOL) --mode=compile gcc -DHAVE_CONFIG_H -I src \
		-I $(COLLECTD_SRC)/src -Wall -Werror $(CFLAGS) -MD -MP -c \
		-o $@ src/write_istatd.c
