#!/usr/bin/env bash

# Fail fast
set -o pipefail
set -eu

APP_CONFIG=/app/config
ROOT=/app/opt
APACHE_ROOT=${ROOT}/apache
SHIB_ROOT=${ROOT}/shibboleth-sp

cp ${APP_CONFIG}/shibboleth2.xml ${SHIB_ROOT}/etc/shibboleth/shibboleth2.xml
echo "${SHIBBOLETH_SP_CERT}" > ${SHIB_ROOT}/etc/shibboleth/sp-cert.pem
echo "${SHIBBOLETH_SP_KEY}" > ${SHIB_ROOT}/etc/shibboleth/sp-key.pem

${APACHE_ROOT}/bin/httpd -f ${APP_CONFIG}/httpd.conf
${SHIB_ROOT}/sbin/shibd -p ${SHIB_ROOT}/var/run/shibd.pid -w 30

tail -F ${APACHE_ROOT}/logs/*.log ${SHIB_ROOT}/var/log/shibboleth/*.log ${SHIB_ROOT}/var/log/httpd/*.log
