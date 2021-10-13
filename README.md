# f1-newrelic-formula

Add the following file to your infrastructure repository in `saltstack/salt/salt/`

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

# To-Do
Create /etc/newrelic-infra.yml based off salt pillar data to enable additional options.

Add logic to define names for hosts in infrastructure monitoring


