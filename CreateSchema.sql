alter session set "_ORACLE_SCRIPT"=true;

CREATE USER JNABCM identified by BCM;

SELECT * FROM dba_users where username='JNABCM'

GRANT ALL PRIVILEGES TO JNABCM; 


