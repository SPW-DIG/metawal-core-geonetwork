mkdir -p /var/log/weekly-aggregation/opendata/
(crontab -l 2>/dev/null; echo "0 0 * * 1 /home/sites/metawal/sources/cronjobs/opendata-weekly-aggregation/opendata-weekly-aggregation.sh >> /var/log/weekly-aggregation/opendata/opendata-weekly-aggregation-\$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1") | crontab -
