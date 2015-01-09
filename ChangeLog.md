#### 2015-01-09 - 1.0.4
* Fixes for RHEL7 iptables and unquoted hash key.

#### 2014-12-16 - 1.0.3
* Rename yum-cron class to yum_cron to avoid forbidden character.
* Add support for RHEL7 in rhel::epel class.
* Clean up to make puppet lint happy.

#### 2014-11-11 - 1.0.2
* Add useful rhel::firewall::notrack definition.

#### 2014-09-15 - 1.0.1
* Manage ip6tables service until the puppetlabs firewall module does.

#### 2014-09-09 - 1.0.0
* Fix in firewall::pre class for when ipv6 is false for rhel::firewall.

#### 2014-04-28 - 0.2.3
* Add rhel::firewall::masquerade class.

#### 2014-02-03 - 0.2.2
* icmp_limit may now be either false or an integer for the reqs/s to allow.
* Support multiport with comma separated dports in proto_dport_source.

#### 2013-11-21 - 0.2.1
* Add virtual class.
* Add firewall::proto_dport_source hack for array sources.
* Support empty port meaning all ports in proto_dport_source.

#### 2013-10-15 - 0.2.0
* Fix defaults for IPv4/IPv6 INPUT chains.
* Add very useful 3-port port knocking feature.
* Add yum-cron class.
* Add net::ifalias definition.
* Add epel class.

#### 2013-10-03 - 0.1.0
* Initial module release.

