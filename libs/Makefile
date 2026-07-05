# Please install the following prerequisites (instructions for each follows):
# 	Android OS SDK: http://source.android.com/download
#
# Install and prepare the Android OS SDK ( http://source.android.com/download )
# on Debian or Ubuntu

EXTERNAL_ROOT := $(shell pwd)

DEBUG ?= 0

MAKE ?= make -j`nproc`

.PHONY = zlib-clean \
	libevent-clean \
	lzma-clean \
	zstd-clean \
	openssl-clean

all: PREBUILD_STATIC_LIBRARY

#------------------------------------------------------------------------------#
# openssl
#
# not all of openssl is needed, only the parts that Tor needs
# https://trac.torproject.org/projects/tor/ticket/32200
# https://gitweb.torproject.org/tor.git/tree/src/lib/tls/ciphers.inc
# https://wiki.openssl.org/index.php/Compilation_and_Installation

openssl/Makefile: openssl/Configure $(wildcard openssl/Configurations/*.*)
	cd openssl && \
		./Configure \
			no-shared no-ssl3 no-tls1 no-tls1_1 \
			no-ocsp no-nextprotoneg no-psk no-srp no-ts \
			no-cmp no-cms no-ct no-dgram no-dtls no-http \
			no-quic no-srtp no-argon2 no-aria no-bf \
			no-blake2 no-camellia no-cast no-des no-dsa \
			no-gost no-idea no-integrity-only-ciphers no-md2 \
			no-md4 no-mdc2 no-ml-dsa no-ocb no-rc2 no-rc4 \
			no-rc5 no-rmd160 no-scrypt no-seed no-siphash \
			no-slh-dsa no-sm2 no-sm3 no-sm4 no-whirlpool \
			no-ec2m no-ssl-trace no-tls-deprecated-ec \
			no-siv no-tests no-padlockeng no-ui-console \
			no-apps no-async no-comp no-ktls no-legacy no-zlib \
			--prefix=/build_libs \
			--libdir=/build_libs/lib \
			--openssldir=/build_libs

openssl-build-stamp: openssl/Makefile
	PATH=$(PATH) make -j`nproc` -C openssl install_dev DESTDIR=$(EXTERNAL_ROOT)
	touch $@

openssl-clean:
	-rm -f openssl-build-stamp
	-cd openssl && \
		git clean -fdx && \
		git reset --hard && \
		git submodule foreach --recursive git clean -fdx && \
		git submodule foreach --recursive git reset --hard

#------------------------------------------------------------------------------#
# libevent

libevent/Makefile: libevent/Makefile.am libevent/configure.ac
	cd libevent && ./autogen.sh
	cd libevent && ./configure \
				LDFLAGS="-L../build_libs/lib" \
				CFLAGS="-I../build_libs/include" \
				--disable-libevent-regress \
				--disable-samples \
				--disable-shared \
			        --prefix=/build_libs

libevent-build-stamp: libevent/Makefile
	$(MAKE) -C libevent install DESTDIR=$(EXTERNAL_ROOT)
	touch $@

libevent-clean:
	-rm -f build_libs/lib/libevent.a
	-rm -f libevent-build-stamp
	-$(MAKE) -C libevent uninstall DESTDIR=$(EXTERNAL_ROOT)
	-$(MAKE) -C libevent clean
	-cd libevent && \
		git clean -fdx && \
		git reset --hard


#------------------------------------------------------------------------------#
# lzma

xz/Makefile: xz/configure.ac xz/Makefile.am
	cd xz && ./autogen.sh
	cd xz && ./configure \
			--enable-static \
			--disable-doc \
			--disable-lzma-links \
			--disable-lzmadec \
			--disable-lzmainfo \
			--disable-scripts \
			--disable-shared \
			--disable-xz \
			--disable-xzdec \
			--prefix=/build_libs

lzma-build-stamp: xz/Makefile
	$(MAKE) -C xz install DESTDIR=$(EXTERNAL_ROOT)
	touch $@

lzma-clean:
	-$(MAKE) -C xz uninstall DESTDIR=$(EXTERNAL_ROOT)
	-$(MAKE) -C xz clean
	-rm -rf include/lzma
	-rm -f include/lzma.h
	-rm -f lib/liblzma.a
	-rm -f lib/liblzma.la
	-rm -f lzma-build-stamp
	-cd xz && \
		git clean -fdx && \
		git reset --hard

#------------------------------------------------------------------------------#
# zlib

zlib-build-stamp:
	cd zlib && ./configure \
		--static \
		--prefix=/build_libs
	$(MAKE) -C zlib install DESTDIR=$(EXTERNAL_ROOT)
	touch $@

zlib-clean:
	-$(MAKE) -C zlib uninstall DESTDIR=$(EXTERNAL_ROOT)
	-$(MAKE) -C zlib clean
	-rm -f lib/libz.a
	-rm -f lib/pkgconfig/zlib.pc
	-rm -f include/zconf.h
	-rm -f include/zlib.h
	-rm -f zlib-build-stamp
	-rm -f share/man/man3/zlib.3
	-cd zlib && \
		git clean -fdx && \
		git reset --hard


#------------------------------------------------------------------------------#
# zstd

zstd-build-stamp:
	$(MAKE) -C zstd/lib \
		PREFIX=$(EXTERNAL_ROOT)/build_libs \
		libzstd.a-mt
	$(MAKE) -C zstd/lib \
		PREFIX=$(EXTERNAL_ROOT)/build_libs \
		libzstd.pc
	test -d build_libs/lib || mkdir -p build_libs/lib
	test -d build_libs/lib/pkgconfig || mkdir -p build_libs/lib/pkgconfig
	test -d build_libs/include || mkdir -p build_libs/include
	cp zstd/lib/libzstd.a build_libs/lib
	cp zstd/lib/libzstd.pc build_libs/lib/pkgconfig
	cp zstd/lib/zstd.h build_libs/include
	cp zstd/lib/deprecated/zbuff.h build_libs/include
	cp zstd/lib/zstd_errors.h build_libs/include
	cp zstd/lib/zdict.h build_libs/include
	touch $@

zstd-clean:
	-rm -f build_libs/include/zstd.h build_libs/include/zstd_errors.h build_libs/include/zbuff.h build_libs/include/zdict.h
	-rm -f build_libs/lib/libzstd.a
	-rm -f build_libs/lib/pkgconfig/libzstd.pc
	-rm -f zstd-build-stamp
	-$(MAKE) -C zstd uninstall
	-$(MAKE) -C zstd clean
	-cd zstd && \
		git clean -fdx && \
		git reset --hard


tor: openssl-build-stamp zlib-build-stamp lzma-build-stamp zstd-build-stamp libevent-build-stamp

PREBUILD_STATIC_LIBRARY: tor

build-clean:
	-rm -rf build_libs

clean: openssl-clean zlib-clean libevent-clean lzma-clean zstd-clean build-clean

