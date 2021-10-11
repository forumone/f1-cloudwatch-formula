{% from "f1newrelic/map.jinja" import project, newrelic_license with context %}

newrelic_infra_repo:
  pkgrepo.managed:
    - humanname: New Relic Infrastructure
    - enabled: True 
    - baseurl: https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/x86_64/
    - gpgcheck: 1
    - key_url: https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg

newrelic_infra_install:
  cmd.run:
    - name: yum install newrelic-infra -y
  require:
    - pkgrepo: newrelic_infra_repo

/etc/newrelic-infra.yml:
  file.managed:
    - name: /etc/newrelic-infra.yml
    - user: root
    - mode: 0640
    - contents: |
        license_key: {{ newrelic_license }}

newrelic-infra:
  service.running:
    - enable: True
    - watch:
      - file: /etc/newrelic-infra.yml