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
  pkg.installed
    
/etc/newrelic-infra.yml:
  file.managed:
    - name: /etc/newrelic-infra.yml
    - user: root
    - mode: 0640
    - contents: |
        license_key: {{ newrelic_license }}
    {% if grains.roles is defined and 'web-server' in grains.roles %}
        display_name: {{ project }}.byf1.dev ({{ infra_agent_name }})
    {% endif %}

newrelic-infra.service:
  service.running:
    - enable: True
    - watch:
      - file: /etc/newrelic-infra.yml
  require:
    - pkg: newrelic-infra