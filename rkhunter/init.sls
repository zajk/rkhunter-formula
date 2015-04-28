{% from "rkhunter/map.jinja" import rkhunter with context -%}

{%- if grains['os_family'] == 'RedHat' %}
repoforge:
  pkg.installed:
    - sources:
      - rpmforge-release: {{ rkhunter.base_url }}.el{{ grains['osmajorrelease'] }}.rf.{{ grains['cpuarch'] }}.rpm
{%- endif %}

rkhunter:
  pkg.installed:
    - name: {{ rkhunter.package }}

{{ rkhunter.conf_file }}:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://rkhunter/files/rkhunter.conf
    - template: jinja
    - require:
      - pkg: {{ rkhunter.package }}

rkhunter_baseline:
  cmd.run:
    - name: rkhunter --update && rkhunter --propupd && touch {{ rkhunter.baseline_lock }}
    - unless: ls {{ rkhunter.baseline_lock }}
    - use_vt: True
    - require:
      - file: /etc/rkhunter.conf
