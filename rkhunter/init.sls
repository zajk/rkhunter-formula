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

/usr/local/rkhunter_baseline.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://rkhunter/files/baseline.sh
    - template: jinja
    - require:
      - pkg: {{ rkhunter.package }}

rkhunter_baseline_run:
  cmd.run:
    - name: bash -x /usr/local/rkhunter_baseline.sh
    - use_vt: True
    - require:
      - file: /etc/rkhunter.conf
