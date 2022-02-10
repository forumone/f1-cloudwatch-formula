/etc/newrelic-infra/logging.d/logging.yml:
  file.managed:
    - source: salt://f1newrelic/files/file.yml.jinja
    - template: jinja
    - user: root
    - mode: 0640