mkdir -p /var/log/weekly-aggregation/distributor/
(crontab -l 2>/dev/null; echo "0 0 * * 1 /home/sites/metawal/sources/cronjobs/distributor-weekly-aggregation/distributor-weekly-aggregation.sh >> /var/log/weekly-aggregation/distributor/distributor-weekly-aggregation-\$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1") | crontab -
