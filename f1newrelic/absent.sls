newrelic-infra-repo:
  pkgrepo.absent:
    - name: newrelic-infra

newrelic-infra:
  pkg.removed

/etc/newrelic-infra.yml:
  file.absent

/etc/newrelic-infra/logging.d/logging.yml:
  file.absent

# Only run on machines running php-fpm
{% if 'web-server' in grains.get('roles', []) %}
newrelic_packages_repo:
  pkgrepo.absent:
    - name: newrelic

newrelic_pkg:
  pkg.removed:
    - name: newrelic-php5

newrelic_php5_common_removed:
  pkg.removed:
    - name: newrelic-php5-common

newrelic_cfg:
  file.absent:
    - name: /etc/php.d/50-newrelic.ini

phpini_no:
  file.absent:
    - name: /etc/php.d/newrelic.ini 

newrelic_nginx:
  service.running:
    - name: nginx
    - onlyif:
      - test -e /usr/sbin/nginx
    - watch:
      - newrelic_pkg

newrelic_fpm:
  service.running:
    - name: php-fpm
    - onlyif:
      - test -e /sbin/php-fpm
    - watch:
      - newrelic_pkg     
{% endif %}