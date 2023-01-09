{% if 'web-server' in grains.get('roles',[]) %}
{% from "f1newrelic/map.jinja" import project, newrelic_license with context %}

newrelic_repo:
  pkg.installed:
    - sources:
      - newrelic-repo: https://yum.newrelic.com/pub/newrelic/el5/x86_64/newrelic-repo-5-3.noarch.rpm

newrelic_pkg:
  pkg.installed:
    - name: newrelic-php5
    - require:
      - newrelic_repo

newrelic_cfg:
  file.managed:
    - name: /etc/php.d/50-newrelic.ini
    - user: root
    - group: root
    - mode: 644
    - contents: |
        extension = "newrelic.so"
        newrelic.license = "{{ newrelic_license }}"
        newrelic.appname = "{{ project }}.byf1.dev"
        newrelic.logname = "/var/log/newrelic/php_agent.log"
        newrelic.distributed_tracing_enabled = true
        newrelic.framework.wordpress.hooks = false
        newrelic.framework.drupal.modules = 0

newrelic_apm_install:
  cmd.run:
    - name: newrelic-install install
    - env:
      - NR_INSTALL_SILENT: '1'
    - require:
      - newrelic_pkg
      - newrelic_cfg
    - unless: pgrep newrelic-daemon

phpini_no:
  file.absent:
    - name: /etc/php.d/newrelic.ini
    - require:
      - newrelic_apm_install    

newrelic_nginx:
  service.running:
    - name: nginx
    - onlyif:
      - test -e /usr/sbin/nginx
    - watch:
      - newrelic_apm_install
      - newrelic_cfg
      - phpini_no

newrelic_fpm:
  service.running:
    - name: php-fpm
    - onlyif:
      - test -e /sbin/php-fpm
    - watch:
      - newrelic_apm_install
      - newrelic_cfg
      - phpini_no

{% endif %}