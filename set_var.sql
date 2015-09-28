drop table IF EXISTS import_var;
create table import_var(name varchar, val varchar);
truncate table import_var;
insert into import_var VALUES ('DB_BACKUP_PATH_ORIGIN',:'DB_BACKUP_PATH_ORIGIN');
insert into import_var VALUES ('DB_BACKUP_PATH',:'DB_BACKUP_PATH');