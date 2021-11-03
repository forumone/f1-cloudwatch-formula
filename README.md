# f1-newrelic-formula

Create the following file to your infrastructure repository in `saltstack/salt/salt/newrelic.sls`


```
newrelic:
  grains.present:
    - value: True

newrelic_remote:
  file.append:
    - name: /etc/salt/master.d/git_remotes.conf
    - text: "  - https://github.com/forumone/f1-newrelic-formula.git:\n    - base: main"

newrelic_reload_salt_master:
  service.running:
    - name: salt-master
    - watch:
      - newrelic_remote

{% if grains.newrelic is defined and grains.newrelic == True %}
include:
  - f1newrelic
 {% if grains.roles is defined and 'web-server' in grains.roles %}
  - f1newrelic.php
  {% endif %}
{% endif %}
```

Add `salt.newrelic` to your top file to `'*'`

# To-Do
Create /etc/newrelic-infra.yml based off salt pillar data to enable additional options.

Add logic to define names for hosts in infrastructure monitoring


