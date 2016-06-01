# Ansible Role: Bind

Installs and configures BIND9 in a simple one Master, one Slave configuration.

## Requirements

None.

## Role Handlers

|Name|Type|Description|
|----|-----------|-------|
`bind restart`|Service|Restart bind server.|

## Role Variables

|Name|Default|Type|Description|
|----|----|-----------|-------|
`bind_role`|`master`|String|The BIND9 role, `master` or `slave` allowed.|
`clients`|`['0.0.0.0/0']`|Array|The array addresses passed to `allow-recursion`.|
`forwarders`|`[]`|Array|The array of `forwarders`.|
`master`||String (IP address)|The address of the BIND9 Master.|
`slave`||String (IP address)|The address of the BIND9 Slave.|
`named_root`||String (filepath)|The `named.root` file.|
`zones_source`||String (filepath)|The path to the zone files.|
`zones`|`[]`|Array|The array of zone files in `zones_source`.|

## Configuration example

```yaml
---
bind_role: master
clients:
  - '0.0.0.0/0'
forwarders:
  - '10.0.1.10'
  - '10.0.1.11'
master: '10.0.0.10'
slave: '10.0.0.11'
named_root: "{{ playbook_dir ~ '/files/bind/named.root' }}",
zones_source: "{{ playbook_dir ~ '/files/bind/zones' }}",
zones:
  - '0.168.192.in-addr.arpa.db'
  - 'example.com.db'
```

## Example playbook

```yaml
  - hosts: servers
    roles:
    - ansible-bind
```

## License

MIT.

## Acknowledgements

This module was based on a Puppet module by Jonathan Kinred.

## Contributing

To run the tests:

```
$ gem install bundler
$ bundle install
$ bundle exec kitchen test default-centos-72
```

Requires Ruby (tested on 2.0.0p481), Ruby Gems and Vagrant.
