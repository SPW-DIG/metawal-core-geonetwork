SELECT cron.schedule(
         'disable_inactive_users_job',
         '0 0 * * 0',  -- At 00:00 every Sunday
         $$ UPDATE users SET isenabled='n' WHERE CAST(lastlogindate AS timestamp) < CURRENT_DATE - INTERVAL '1 year' and isenabled = 'y'; $$
       );
