#### 2018-05-31 - 1.0.13
* Allow masquerading multiple interfaces (#3, @forgodssake).

#### 2017-01-26 - 1.0.12
* Use previously defined $cron_ensure parameter (#3 @lisuml).
* Fix unknown variable warning for final_dport.

#### 2016-02-08 - 1.0.11
* Add chmod exec to remove +x from ebtables.service to avoid noise in logs.

#### 2015-10-15 - 1.0.10
* Add rhel::firewall::masquerade::return_local for IPSec.
* Split $seconds into $seconds_knock and $seconds_open for portknock.
* Add rhel::aide definition to monitor and report filesystem changes.

#### 2015-07-15 - 1.0.9
* Force expire-cache in yum-cron and add dnf support.

#### 2015-05-20 - 1.0.8
* Compatibility fixes for Puppet 4.

#### 2015-04-28 - 1.0.7
* Add rhel::firewall::privatesrc definition.
* Make forge score happy.

#### 2015-03-31 - 1.0.5
* Fix firewall::masquerade by adding FORWARD rules.
* Add systemd class and systemd::service definition.

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

