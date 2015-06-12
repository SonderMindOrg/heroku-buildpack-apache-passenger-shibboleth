# Heroku Buildpack: Apache + Phusion Passenger + Shibboleth

[Shibboleth](https://shibboleth.net/) is a SAML-based single sign-on (SSO) solution popular in higher education. It can be used standalone or as part of a federation such as [InCommon](https://www.incommon.org/). The best supported Linux deployment of the Shibboleth service provider (SP) software is an [Apache](http://httpd.apache.org/) module that communicates with a daemon through a Unix socket. This buildpack enables support for Shibboleth providing authentication for a Rails application running on Heroku by installing pre-built versions of Apache, [Phusion Passenger](https://www.phusionpassenger.com/), and Shibboleth itself.

## Versions

* Apache: 2.4.12, with dependencies:
 * zlib: 1.2.8
 * PCRE: 8.37
* Phusion Passenger: 4.0.59
* Shibboleth SP: 2.5.4, with dependencies:
 * Boost (headers): 1.52
 * Log4Shib: 1.0.9
 * XercesC: 3.1.2
 * XMLSecurityC: 1.7.3
 * XMLTooling: 1.5.4
 * OpenSAML: 2.5.4

## Dependencies

* The official ruby buildpack from Heroku.
* The presence of the files `config/httpd.conf` and `config/shibboleth2.xml` in the application directory.

## Usage

Add the official Ruby buildpack and this buildpack to the list of buildpacks for your application:

    heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby.git -a {your app}
    heroku buildpacks:add https://github.com/uvize/heroku-buildpack-apache-passenger-shibboleth.git -a {your app}

Your app will have working installations of the packages in the directories `/app/opt/apache`, `/app/opt/shibboleth-sp`, and `/app/opt/passenger`.

### Configuration and running

Example `httdp.conf` and `shibboleth2.xml` configuration files are included in the `examples` directory, along with a `web.sh` script demonstrating how the daemons could be run on a dyno as the `web` entry in a `Procfile`. For now, these are merely illustrative, and you're encouraged to make your own versions in your project.

## Building

If you want to host your own versions of the package files, change compile-time configuration, or build new versions, you can deploy this repository as a new application and use the scripts provided in the `scripts` directory from a one-off dyno. The `build-` scripts will download dependencies, configure, build, and install each package. You can then create tarballs, and use the `support/upload.rb` script to upload them to S3. One caveat is that building passenger depends on already having built apache. An example session:

    heroku apps:create -s cedar
    heroku config:set AWS_ACCESS_KEY_ID={your S3 key id} AWS_SECRET_ACCESS_KEY={your S3 secret key}
    git push heroku master
    heroku run bash
    # On the dyno
    scripts/build-apache.sh
    # ... lots of output ...
    tar czf apache-2.4.12.tar.gz opt/apache
    scripts/support/upload.rb {S3 bucket name} apache-2.4.12.tar.gz {S3 key name}
    scripts/build-passenger.sh
    # ... lots of output ...
    tar czf passenger-4.0.59.tar.gz opt/passenger
    scripts/support/upload.rb {S3 bucket name} passenger-4.0.59.tar.gz {S3 key name}
    scripts/build-shibboleth.sh
    # ... lots of output ...
    tar czf shibboleth-sp-2.5.4.tar.gz opt/shibboleth-sp
    scripts/support/upload.rb {S3 bucket name} shibboleth-sp-2.5.4.tar.gz {S3 key name}
