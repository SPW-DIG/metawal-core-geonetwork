SELECT surname, name, organisation, isenabled, lastlogindate FROM users WHERE CAST(lastlogindate AS timestamp) < CURRENT_DATE - INTERVAL '1 year' and isenabled = 'y';
