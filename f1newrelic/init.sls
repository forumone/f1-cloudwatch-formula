{% from "f1newrelic/map.jinja" import project, newrelic_license with context %}

newrelic-infra-repo:
  pkgrepo.managed:
    - name: newrelic-infra
    - humanname: New Relic Infrastructure
    - enabled: True 
    - baseurl: https://download.newrelic.com/infrastructure_agent/linux/yum/amazonlinux/2/x86_64/
    - gpgcheck: 1
    - repo_gpgcheck: 1
    - gpgkey: https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg

newrelic-infra:
  pkg.installed
    


# newrelic_infra_install:
#   cmd.run:
#     - name: yum install newrelic-infra -y
#   require:
#     - pkgrepo: newrelic-infra

/etc/newrelic-infra.yml:
  file.managed:
    - name: /etc/newrelic-infra.yml
    - user: root
    - mode: 0640
    - contents: |
        license_key: {{ newrelic_license }}

newrelic-infra.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/newrelic-infra.yml
  require:
    - 