mkdir -p /var/log/daily-aggregation/record-count/
(crontab -l 2>/dev/null; echo "0 0 * * * /home/sites/metawal/sources/cronjobs/record-count-daily-aggregation/record-count-daily-aggregation.sh >> /var/log/daily-aggregation/record-count/record-count-daily-aggregation-\$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1") | crontab -
