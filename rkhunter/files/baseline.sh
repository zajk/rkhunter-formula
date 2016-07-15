{% from "rkhunter/map.jinja" import rkhunter with context -%}
#!/bin/bash

LOCK_FILE='/var/lib/rkhunter_baseline'

if [ ! -f $LOCK_FILE ]; then
	rkhunter --versioncheck --update --propupd --nocolors > /tmp/rkhunter.tmp
	mail -s "[rkhunter] First rootkit hunter run on {{ salt['grains.get']('fqdn') }}" {{ rkhunter.email }} < /tmp/rkhunter.tmp
	touch $LOCK_FILE
else
	exit 0
fi