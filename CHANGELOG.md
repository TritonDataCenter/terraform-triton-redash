
## 1.0.0-rc2 (Unreleased)

BACKWARDS INCOMPATIBILITIES / NOTES:

  * Changes for [terraform-triton-bastion - 1.0.0-rc2](https://github.com/joyent/terraform-triton-bastion/blob/master/CHANGELOG.md#100-rc2-unreleased).
  * Change `redash_ip` output to `redash_primaryip`. 
  * Remove `role_tag` variable and `redash_role_tag` output.
  * Change `cns_fqdn_base` default value. 

IMPROVEMENTS:

  * Change firewall rules to rely on CNS service names instead of (now removed) `role` tag.
  
## 1.0.0-rc1 (2018-02-10)

  * Initial working example
