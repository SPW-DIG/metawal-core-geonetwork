SELECT username FROM users WHERE username not in('SPBTIT','vbombaerts_admin','MLouis_Admin','FMEupdate') and (authtype is null  or authtype != 'LDAP') and isenabled='y';
UPDATE users SET isenabled='n' WHERE username not in('SPBTIT','vbombaerts_admin','MLouis_Admin','FMEupdate') and (authtype is null  or authtype != 'LDAP') and isenabled='y';
