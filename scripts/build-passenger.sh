#!/usr/bin/env bash

source $(dirname "$0")/support/setup.sh

BUILD_DIR=${APP_DIR}/build/passenger

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}

PASSENGER="passenger-4.0.59"
if [ ! -d "${PASSENGER}" ]; then
  ARCHIVE=${PASSENGER}.tar.gz
  if [ ! -f "${ARCHIVE}" ]; then
    $get http://s3.amazonaws.com/phusion-passenger/releases/${ARCHIVE}
    $get https://s3.amazonaws.com/phusion-passenger/releases/${ARCHIVE}.asc
    $verify ${ARCHIVE}.asc
  fi
  $extract ${ARCHIVE}
fi

rm -f *.tar.gz*

PREFIX=${INSTALL_DIR}/passenger

pushd ${PASSENGER}
./bin/passenger-install-apache2-module -a --languages ruby
popd

mv ${PASSENGER} ${PREFIX}
