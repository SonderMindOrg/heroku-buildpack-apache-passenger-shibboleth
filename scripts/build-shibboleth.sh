#!/usr/bin/env bash

source $(dirname "$0")/support/setup.sh

BUILD_DIR=${APP_DIR}/build/shibboleth

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

BOOST="boost_1_52_0"
if [ ! -d "${BOOST}" ]; then
  ARCHIVE=${BOOST}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    # No signature available, at least we can get from https.
    $get https://downloads.sourceforge.net/project/boost/boost/1.52.0/${ARCHIVE}
  fi
  $extract ${ARCHIVE}
fi

LOG4SHIB="log4shib-1.0.9"
if [ ! -d "${LOG4SHIB}" ]; then
  ARCHIVE=${LOG4SHIB}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://shibboleth.net/downloads/log4shib/latest/${ARCHIVE}
    $get https://shibboleth.net/downloads/log4shib/latest/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

XERCESC="xerces-c-3.1.1"
if [ ! -d "${XERCESC}" ]; then
  ARCHIVE=${XERCESC}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://www.apache.org/dist/xerces/c/3/sources/${ARCHIVE}
    $get https://www.apache.org/dist/xerces/c/3/sources/${ARCHIVE}.asc
    $verify ${XERCESC}.tar.gz.asc
  fi
  $extract ${XERCESC}.tar.gz
fi

XMLSECURITYC="xml-security-c-1.7.2"
if [ ! -d "${XMLSECURITYC}" ]; then
  ARCHIVE=${XMLSECURITYC}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://www.apache.org/dist/santuario/c-library/${ARCHIVE}
    $get https://www.apache.org/dist/santuario/c-library/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

XMLTOOLING="xmltooling-1.5.3"
if [ ! -d "${XMLTOOLING}" ]; then
  ARCHIVE=${XMLTOOLING}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://shibboleth.net/downloads/c++-opensaml/2.5.3/${ARCHIVE}
    $get https://shibboleth.net/downloads/c++-opensaml/2.5.3/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

OPENSAML="opensaml-2.5.3"
if [ ! -d "${OPENSAML}" ]; then
  ARCHIVE=${OPENSAML}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://shibboleth.net/downloads/c++-opensaml/2.5.3/${ARCHIVE}
    $get https://shibboleth.net/downloads/c++-opensaml/2.5.3/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

SHIBBOLETHSP="shibboleth-sp-2.5.3"
if [ ! -d "${SHIBBOLETHSP}" ]; then
  ARCHIVE=${SHIBBOLETHSP}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://shibboleth.net/downloads/service-provider/latest/${ARCHIVE}
    $get https://shibboleth.net/downloads/service-provider/latest/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

rm -f *.tar.gz*

PREFIX=${INSTALL_DIR}/shibboleth-sp

# log4shib
pushd ${LOG4SHIB}
./configure --prefix=${PREFIX} --disable-static --disable-doxygen
make && make install
popd

# xerces-c
pushd ${XERCESC}
./configure --prefix=${PREFIX} --disable-netaccessor-libcurl
make && make install
popd

# xml-security-c
pushd ${XMLSECURITYC}
./configure --prefix=${PREFIX} --with-xerces=${PREFIX} --without-xalan --disable-static
make && make install
popd

# xml-tooling-c
pushd ${XMLTOOLING}
./configure --prefix=${PREFIX} --with-log4shib=${PREFIX} -C CPPFLAGS="-I${BUILD_DIR}/${BOOST}"
make && make install
popd

# opensaml-c
pushd ${OPENSAML}
./configure --prefix=${PREFIX} --with-log4shib=${PREFIX} -C CPPFLAGS="-I${BUILD_DIR}/${BOOST}"
make && make install
popd

# shibboleth
pushd ${SHIBBOLETHSP}
./configure --prefix=${PREFIX} --with-log4shib=${PREFIX} --with-apxs2=${INSTALL_DIR}/apache/bin/apxs CPPFLAGS="-I${BUILD_DIR}/${BOOST}"
make && make install
popd
