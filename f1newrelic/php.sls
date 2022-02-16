{% from "f1newrelic/map.jinja" import project, newrelic_license with context %}

newrelic_repo:
  pkg.installed:
    - sources:
      - newrelic-repo: https://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm


newrelic_pkg:
  pkg.installed:
    - name: newrelic-php5

newrelic_cfg:
  file.managed:
    - name: /etc/php.d/50-newrelic.ini
    - user: root
    - group: root
    - mode: 644
    - contents: |
        extension=newrelic
        newrelic.appname={{ project }}.byf1.dev
        newrelic.logname="/var/log/newrelic/php_agent.log"

newrelic_key:
  file.managed:
    - name: /etc/php.d/newrelic.ini
    - user: root
    - group: root
    - mode: 644
    - contents: |
        newrelic.license = "{{ newrelic_license }}"
        # debug entries
        newrelic.loglevel = "verbosedebug"
        newrelic.daemon.loglevel = "verbosedebug"
        newrelic.logfile = "/var/log/newrelic/php_agent.log"
        newrelic.daemon.logfile = "/var/log/newrelic/newrelic-daemon.log"
        newrelic.daemon.auditlog = "/var/log/newrelic/audit.log"

newrelic_apm_install:
  cmd.run:
    - name: newrelic-install install
    - env:
      - NR_INSTALL_SILENT: '1'
    - onchanges:
      - file: newrelic_key

newrelic_nginx:
  service.running:
    - name: nginx
    - onlyif:
      - test -e /usr/sbin/nginx
    - watch:
      - newrelic_apm_install

newrelic_fpm:
  service.running:
    - name: php-fpm
    - onlyif:
      - test -e /sbin/php-fpm
    - watch:
      - newrelic_apm_install