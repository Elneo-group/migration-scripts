SELECT 'DROP INDEX IF EXISTS fk_' || conname || '_idx; CREATE INDEX fk_' || conname || '_idx ON ' 
       || relname || ' ' || 
       regexp_replace(
           regexp_replace(pg_get_constraintdef(pg_constraint.oid, true), 
           ' REFERENCES.*$','',''), 'FOREIGN KEY ','','') || ';'
FROM pg_constraint 
JOIN pg_class 
    ON (conrelid = pg_class.oid)
JOIN pg_namespace
    ON (relnamespace = pg_namespace.oid)
WHERE contype = 'f'
  AND nspname = 'public'
  --AND 'fk_' || conname || '_idx' NOT IN (SELECT indexname FROM pg_indexes)
  ;