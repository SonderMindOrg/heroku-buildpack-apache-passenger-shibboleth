# Heroku Buildpack: Apache + Phusion Passenger + Shibboleth

[Shibboleth](https://shibboleth.net/) is a SAML-based single sign-on (SSO) solution popular in higher education. It can be used standalone or as part of a federation such as [InCommon](https://www.incommon.org/). The best supported Linux deployment of the Shibboleth service provider (SP) software is an [Apache](http://httpd.apache.org/) module that communicates with a daemon through a Unix socket. This buildpack enables support for Shibboleth providing authentication for a Rails application running on Heroku by installing pre-built versions of Apache, [Phusion Passenger](https://www.phusionpassenger.com/), and Shibboleth itself.

## Versions

* Apache: 2.4.12, with dependencies:
 * zlib: 1.2.8
 * PCRE: 8.36
* Phusion Passenger: 4.0.59
* Shibboleth SP: 2.5.3, with dependencies:
 * Boost (headers): 1.52
 * Log4Shib: 1.0.9
 * XercesC: 3.1.1
 * XMLSecurityC: 1.7.2
 * XMLTooling: 1.5.3
 * OpenSAML: 2.5.3

## Requirements

* The official ruby buildpack from Heroku (using [heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi)).
* The presence of the files `config/httpd.conf` and `config/shibboleth2.xml` in the application directory.
