#!/usr/bin/env bash

ZLIB_VERSION="1.2.8"
PCRE_VERSION="8.37"
APACHE_VERSION="2.4.12"

source $(dirname "$0")/support/setup.sh

BUILD_DIR=${APP_DIR}/build/apache

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

ZLIB="zlib-${ZLIB_VERSION}"
if [ ! -d "${ZLIB}" ]; then
  ARCHIVE=${ZLIB}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://downloads.sourceforge.net/project/libpng/zlib/${ZLIB_VERSION}/${ARCHIVE}
    $get https://downloads.sourceforge.net/project/libpng/zlib/${ZLIB_VERSION}/Gnupg/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

PCRE="pcre-${PCRE_VERSION}"
if [ ! -d "${PCRE}" ]; then
  ARCHIVE=${PCRE}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/${ARCHIVE}
    $get https://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/${ARCHIVE}.sig
    $verify ${ARCHIVE}.sig
  fi
  $extract ${ARCHIVE}
fi

APACHE="httpd-${APACHE_VERSION}"
if [ ! -d "${APACHE}" ]; then
  ARCHIVE=${APACHE}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://www.apache.org/dist/httpd/${ARCHIVE}
    $get https://www.apache.org/dist/httpd/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}

  ARCHIVE=${APACHE}-deps.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://www.apache.org/dist/httpd/${ARCHIVE}
    $get https://www.apache.org/dist/httpd/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

rm -f *.tar.gz*

PREFIX=${INSTALL_DIR}/apache

pushd ${ZLIB}
./configure --prefix=${PREFIX}
make && make install
popd

pushd ${PCRE}
./configure --prefix=${PREFIX}
make && make install
popd

pushd ${APACHE}
# Config options adapted from ubuntu package for 14.04
./configure --prefix=${PREFIX} \
            --with-included-apr \
            --enable-so \
            --enable-log-config=static \
            --with-pcre=${PREFIX} \
            --with-z=${PREFIX} \
            --enable-pie \
            --enable-mpms-shared=all \
            --enable-mods-shared="all cgi" \
            --enable-mods-static="unixd logio watchdog version" \
            --enable-proxy \
            --enable-proxy-fcgi \
            --enable-rewrite \
            --enable-deflate \
            CFLAGS="-pipe -g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security" \
            CPPFLAGS="-D_FORTIFY_SOURCE=2" \
            LDFLAGS="-Wl,--as-needed -Wl,-Bsymbolic-functions -Wl,-z,relro -Wl,-z,now" \
            LTFLAGS="--no-silent"
make && make install
popd
