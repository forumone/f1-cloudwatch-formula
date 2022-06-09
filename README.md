# f1-newrelic-formula

* Formula requires `awscli` and `jq` to be installed on minions

Add the following to the `utility_server.tpl` in the section with other Salt git remotes:
```
- https://github.com/forumone/f1-newrelic-formula.git:\n    
  - base: main"
```

OR

Manually add this git remote to the salt master `/etc/salt/master.d/git_remotes.conf`

Then, add `f1newrelic` to the utility instance top fie, and `f1newrelic.php` to any web-servers.

# To-Do
Create /etc/newrelic-infra.yml based off salt pillar data to enable additional options.

Add logic to define names for hosts in infrastructure monitoring