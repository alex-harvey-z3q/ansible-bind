# Ansible Role: Bind

Installs and configures BIND9 in a Master/Slave configuration.

## Architecture

The architecture is shown in the following figure:

![Fig 1](./arch.png)

## Requirements

None.

## Role Handlers

|Name|Type|Description|
|----|-----------|-------|
`bind restart`|Service|Restart bind server.|

## Role Variables

### Variables in all BIND9 roles

|Name|Default|Type|Description|
|----|----|-----------|-------|
|`bind_role`|`master`|String|The BIND9 role, `master` or `slave` allowed.|
|`listen_on`||Array|The array of addresses to `listen-on`.|
|`allow_recursion`|`['0.0.0.0/0']`|Array|The array of addresses passed to `allow-recursion`.|
|`forwarders`|`['8.8.8.8', '8.8.4.4']`|Array|The array of `forwarders`.|
|`named_root`||String (filepath)|The `named.root` file.|
|`zones`||Array|The array of zone files in `zones_source`.|

### Variables for Master role only

|Name|Default|Type|Description|
|----|----|-----------|-------|
|`slaves`||Array|The list of BIND9 slaves.|
|`zone_files_source`||String (filepath)|The path to the zone files.|

### Variables for Slave role only

|Name|Default|Type|Description|
|----|----|-----------|-------|
|`master`||String|The address of the master.|

## Configuration example

### Master

```yaml
---
bind_role: master
listen_on:
  - '127.0.0.1'
  - '10.0.0.10'
allow_recursion:
  - '0.0.0.0/0'
forwarders:
  - '8.8.8.8'
  - '8.8.4.4'
slaves:
  - '10.0.0.11'
  - '10.0.0.12'
named_root: "{{ playbook_dir ~ '/files/bind/named.root' }}"
zone_files_source: "{{ playbook_dir ~ '/files/bind/zones' }}"
zones:
  - '0.0.10.in-addr.arpa.db'
  - 'example.com.db'
```

### Slave

```yaml
---
bind_role: slave
listen_on:
  - '127.0.0.1'
  - '10.0.0.10'
allow_recursion:
  - '0.0.0.0/0'
forwarders:
  - '8.8.8.8'
  - '8.8.4.4'
master: '10.0.0.10'
named_root: "{{ playbook_dir ~ '/test/fixtures/named.root' }}"
zones:
  - '0.0.10.in-addr.arpa'
  - 'example.com'
```

## Example playbook

```yaml
---
- hosts: servers
  roles:
  - ansible-bind
```

## License

MIT.

## Acknowledgements

This module is inspired by a Puppet module by [Jonathan Kinred](https://github.com/jkinred).

## Run the tests

This role includes Test Kitchen tests that demonstrate a BIND9 configuration with a Master and two Slaves.

To run the tests:

Make sure you have the following prerequisites installed:

* VirtualBox
* Vagrant
* Ruby Gems
* Ruby (tested on 2.0.0p481).

```
$ gem install bundler
$ bundle install
```

To set up and test the master:

```
$ bundle exec kitchen verify master-centos-72
```

To then set up and test the slaves:

```
$ bundle exec kitchen verify slave1-centos-72
$ bundle exec kitchen verify slave2-centos-72
```

Teardown:

```
$ bundle exec kitchen destroy 
```

## See also

I have a blog post about this module's Test Kitchen setup: [Integration testing using Ansible and Test Kitchen](https://alexharv074.github.io/2016/06/13/integration-testing-using-ansible-and-test-kitchen.html).
