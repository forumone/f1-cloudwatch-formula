{% from "f1newrelic/map.jinja" import project, newrelic_license with context %}

include:
  - f1newrelic.repo

newrelic_infra_install:
  cmd.run:
    - name: yum install newrelic-infra -y

/etc/newrelic-infra.yml:
  file.managed:
    - name: /etc/newrelic-infra.yml
    - user: root
    - mode: 0640
    - contents: |
        license_key: {{ newrelic_license }}