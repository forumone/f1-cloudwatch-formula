{% from "newrelic/map.jinja" import project, newrelic_license with context %}

/srv/salt/newrelic.license.ini:
  file.managed
    - name: /srv/salt/newrelic.license.ini
    - user: root
    - mode: 0660
    - content: |
        newrelic.license = "{{ newrelic_license }}"