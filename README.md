rkhunter-formula
===============

Installs and runs baseline run for rkhunter. It uses default mail command to send emails, so make sure you have SMTP relay setup.

Contributions are welcome.

- Tested on Centos 6.5, could work on RedHat family distributions - maybe broken after the debian support.

- Tested on Ubuntu Trusty and Ubuntu Xenial, could work on other Debian based distributions.

Available states
================

``rkhunter``
------------

Install and configure the ``rkhunter`` package and run baseline run. See the `pillar.example` file for configuration.

Changelog
=========

2016-07-15
----------

- Added support for debian, including debians /etc/default/rkhunter file.
  [pcdummy]
- Added more configuration options.
  [pcdummy]

Authors
=======

- René Jochum <rene@jochums.at>
- Zijad Purkovic <zijadpurkovic@gmail.com>

License
=======

MIT
