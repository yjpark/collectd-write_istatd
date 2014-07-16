write\_istatd
==============

An output plugin for [collectd](http://collectd.org).

*NOTE* The code is a mirror of write\_graphite plugin in [collectd](http://collectd.org/). The only different is the in istatd, the timestamp is expected to be BEFORE value.

- https://github.com/imvu-open/istatd/wiki/Recording-counters

Description
-----------

The write\_istatd plugin sends data to [istatd](https://github.com/imvu-open/istatd) Data is sent in 4K blocks over TCP to istatd.


Installation
------------

First, modify the variables at the top of the Makefile to fit your system. (I use FreeBSD.) Then continue making the project as usual. During the initial make, collectd will be downloaded and configured to provide the neccesary libtool script.

    $ git clone git@github.com:yjpark/collectd-write_istatd.git
    $ cd collectd-write_istatd
    $ make
    $ sudo make install


Configuration
-------------

Enable the plugin in collectd.conf by adding:

    LoadPlugin write_istatd

Configure the plugin to match your carbon configuration.

    <Plugin write_istatd>
      <Carbon>
        Host "localhost"
        Port "2003"
        Prefix "collectd."
      </Carbon>
    </Plugin>

Restart collectd to load the new plugin.

### Available Carbon Configuration Directives

*    Host *required*

     The hostname of the Carbon collection agent.

*    Port *required*

     The port used by the Carbon collect agent.

*    Prefix

     The prefix string prepended to the hostname that is sent to Carbon. Use dots (.) to create folders. A good choise might be "collectd." or "servers."

*    Postfix

     The postfix string appended to the hostname sent to istatd.

*    DotCharacter

     The character used to replace dots (.) in a hostname or datasource name. Defaults to an underscore.
