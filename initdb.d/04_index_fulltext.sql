log_message ("=== Stats on loaded graphs ") ;
sparql SELECT COUNT(*) WHERE { ?s ?p ?o } ;
sparql SELECT ?g COUNT(*) { GRAPH ?g {?s ?p ?o.} } GROUP BY ?g ORDER BY DESC 2;
log_message ("=== Beginning full text indexing on loaded graphs") ;
-- Build Full Text Indexes by running the following commands using the Virtuoso isql program
-- With this rule added, all text in all graphs will be indexed...
echoln "--- Setting up indexing" ;
RDF_OBJ_FT_RULE_ADD (null, null, 'All');
VT_INC_INDEX_DB_DBA_RDF_OBJ ();
echoln "--- Populating lookup table" ;
-- Run the following procedure using the Virtuoso isql program to populate label lookup tables periodically and activate the Label text box of the Entity Label Lookup tab:
urilbl_ac_init_db();
echoln "--- Ranking IRIs" ;
-- Run the following procedure using the Virtuoso isql program to calculate the IRI ranks. Note this should be run periodically as the data grows to re-rank the IRIs.
s_rank();
checkpoint;
commit WORK;
checkpoint;
log_message ("=== Indexing done                                    ===") ;
