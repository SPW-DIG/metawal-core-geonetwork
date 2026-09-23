mkdir -p /var/log/weekly-aggregation/directive/
(crontab -l 2>/dev/null; echo "0 0 * * 1 /home/sites/metawal/sources/cronjobs/directive-weekly-aggregation/directive-weekly-aggregation.sh >> /var/log/weekly-aggregation/directive/directive-weekly-aggregation-\$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1") | crontab -
