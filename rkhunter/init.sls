#!jinja|yaml
# vi: set ft=yaml.jinja :

{% from "rkhunter/map.jinja" import rkhunter with context -%}

{%- if grains['os_family'] == 'RedHat' %}
repoforge:
  pkg.installed:
    - sources:
      - rpmforge-release: {{ rkhunter.lookup.base_url }}.el{{ grains['osmajorrelease'] }}.rf.{{ grains['cpuarch'] }}.rpm
{% else %}
rkhunter:
  pkg.installed:
    - pkgs: {{ rkhunter.lookup.packages }}
{%- endif %}

{{ rkhunter.lookup.conf_file }}:
  file.managed:
    - user: root
    - group: root
    - mode: 0600
    - source: salt://rkhunter/templates/rkhunter.conf.jinja
    - template: jinja
    - require:
      - pkg: rkhunter

{% if rkhunter.lookup.get('defaults_file', False) -%}
{{ rkhunter.lookup.defaults_file }}:
  file.managed:
    - user: root
    - group: root
    - mode: 0600
    - source: salt://rkhunter/templates/debian/defaults.jinja
    - template: jinja
    - require:
      - pkg: rkhunter
{%- endif %}

/usr/local/bin/rkhunter_baseline.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://rkhunter/files/baseline.sh
    - template: jinja
    - require:
      - pkg: rkhunter

rkhunter_baseline_run:
  cmd.run:
    - name: bash /usr/local/bin/rkhunter_baseline.sh
    - unless: ls /var/lib/rkhunter_baseline
    - use_vt: True
    - require:
      - file: {{ rkhunter.lookup.conf_file }}
