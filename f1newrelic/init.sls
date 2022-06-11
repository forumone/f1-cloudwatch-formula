{% from "f1newrelic/map.jinja" import infra_agent_name, project, newrelic_license with context %}

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
  pkg.installed:
    - require:
      - newrelic-infra-repo
    
/etc/newrelic-infra.yml:
  file.managed:
    - source: salt://f1newrelic/files/newrelic-infra.yml.jinja
    - template: jinja
    - name: /etc/newrelic-infra.yml
    - user: root
    - mode: 0640
    - context:
        infra_agent_name: {{ infra_agent_name }}
        newrelic_license: {{ newrelic_license }}
        project:  {{ project }}

/etc/newrelic-infra/logging.d/logging.yml:
  file.managed:
    - source: salt://f1newrelic/files/file.yml.jinja
    - template: jinja
    - user: root
    - mode: 0640

newrelic-infra.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/newrelic-infra.yml
      - file: /etc/newrelic-infra/logging.d/logging.yml
    - require:
      - pkg: newrelic-infra