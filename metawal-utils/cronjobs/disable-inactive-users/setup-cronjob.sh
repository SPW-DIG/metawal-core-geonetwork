mkdir -p /var/log/database/disable-inactive-users/
(crontab -l 2>/dev/null; echo "0 0 * * 1 /home/sites/metawal/sources/cronjobs/disable-inactive-users/disable-inactive-users.sh >> /var/log/database/disable-inactive-users/disable-inactive-users-\$(date +\%Y-\%m-\%d_\%H-\%M-\%S).log 2>&1") | crontab -
