ld_dir ('dataset', '*.ttl', 'http://kaiko.getalp.org/dbnary');
ld_dir ('dataset', '*.ttl.bz2', 'http://kaiko.getalp.org/dbnary');
-- ld_dir ('dataset', '*.ttl.gz', 'http://kaiko.getalp.org/dbnary');
-- ld_dir ('dataset', '*.ttl.xz', 'http://kaiko.getalp.org/dbnary');
-- do the following to see which files were registered to be added:
SELECT * FROM DB.DBA.LOAD_LIST;
-- if unsatisfied use:
-- delete from DB.DBA.LOAD_LIST;
log_message ("=== Loading DBnary data                  ===") ;
rdf_loader_run();
-- do nothing too heavy while data is loading
checkpoint;
commit WORK;
checkpoint;
echoln "========================================================" ;
echoln "=== Looking for errors while loading graphs          ===" ;
echoln "========================================================" ;
-- Check the set of loaded files to see if errors appeared during load.
select * from DB.DBA.LOAD_LIST where ll_error IS NOT NULL;
echoln "=== Loading done                                     ===" ;