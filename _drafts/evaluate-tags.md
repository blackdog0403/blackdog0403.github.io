
### List of tags and usage

#### all
- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.provider/kraken.provider.selector
- roles/kraken.ssh/kraken.ssh.selector
- roles/kraken.readiness,
- roles/kraken.services

#### dryrun

- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.fabric/kraken.fabric.selector

#### always
-  it's on 'kraken.config' role in up.yaml, down.yaml, update.yaml, down.yaml but no in roles and shell files

#### config, config_only
_Those can be combined with a tag_
=> looks like it's being used for "up.sh --generate" at the moment. maybe for schema checking?

#### common, common_only
_can be combined with a tag_

#### nodePools,nodePools_only
_can be combined with a tag_

#### assembler, assembler_only
_can be combined with a tag_

=> TBD


#### provider

- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.provider/kraken.provider.selector
- roles/kraken.fabric/kraken.fabric.selector

#### provider_only
- roles/kraken.provider/kraken.provider.selector


#### ssh
- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.provider/kraken.provider.selector
- roles/kraken.fabric/kraken.fabric.selector
- roles/kraken.ssh/kraken.ssh.selector

#### ssh_only
- roles/kraken.ssh/kraken.ssh.selector

#### readiness
- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.provider/kraken.provider.selector
- roles/kraken.fabric/kraken.fabric.selector
- roles/kraken.readiness

#### readiness_only
- roles/kraken.readiness

#### fabric,fabric_only
- _can be combined with a tag_

#### services
- roles/kraken.cluster_common
- roles/kraken.nodePool/kraken.nodePool.selector
- roles/kraken.assembler
- roles/kraken.provider/kraken.provider.selector
- roles/kraken.readiness
- roles/kraken.fabric/kraken.fabric.selector
- roles/kraken.services

#### services_only
- roles/kraken.services

#### master
- in upgrade.yaml -> will be deprecated.

#### master_ony(typo?)
- in upgrade.yaml -> will be deprecated.


| Role Name  | up.yaml     | down.yaml         | update.yaml  |
| -------------- | ------------ | ----------   | ------------ |
| kraken.config | O | O | O |
| roles.kraken.cluster_common | O |  X | O |
| roles.kraken.nodePool/kraken.nodePool.selector | O | X |  O |
| roles.kraken.assembler | O | X | O |
| roles.kraken.provider/kraken.provider.selector | O | O | O |
| roles.kraken.ssh/kraken.ssh.selector | O | X | O |
| roles.kraken.readiness | O | X | O |
| roles.kraken.fabric/kraken.fabric.selector | O | X | O |
| roles.kraken.services | O |  O | X |
| roles.kraken.clean |  X | O | X |


### Usage
User can use certain part of ansible roles under /k2/roles directory through tags

To use tags user should set environment variable : $KRAKEN_TAGS

For exmple. if you can set  $KRAKEN_TAGS as 'dryrun' to run shell script without spinning up clusters
```
$ export KRAKEN_TAGS="dryrun"
```
Or you can set multiple tags using ',' for delimeter

```
$ export KRAKEN_TAGS="fabric_only, services_only"
```

Then you can verify those tags though stdout output when run some commands like 'up.sh'
```
$ docker run $K2OPTS quay.io/samsung_cnct/k2:latest ./up.sh --config $HOME/.kraken/${CLUSTER}.yaml
WARNING: --output not specified. Using /Users/blackdog/.kraken as location
WARNING: Using 'dryrun' as tags
...
```

### References

http://docs.ansible.com/ansible/playbooks_tags.html
