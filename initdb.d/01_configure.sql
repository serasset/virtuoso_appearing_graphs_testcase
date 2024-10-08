-- noinspection SqlDialectInspectionForFile

-- noinspection SqlNoDataSourceInspectionForFile

DB.DBA.VAD_INSTALL('../vad/isparql_dav.vad', 0);
DB.DBA.VAD_INSTALL('../vad/fct_dav.vad', 0);
DB.DBA.VHOST_REMOVE ( lhost=>'*ini*', vhost=>'*ini*', lpath=>'/dbnary' );

DB.DBA.VHOST_DEFINE (
	 lhost=>'*ini*',
	 vhost=>'*ini*',
	 lpath=>'/dbnary',
	 ppath=>'/DAV/',
	 is_dav=>1,
	 is_brws=>0,
	 def_page=>'',
	 vsp_user=>'dba',
	 ses_vars=>0,
	 opts=>vector ('browse_sheet', '', 'url_rewrite', 'http_rule_list_1', 'cors', '*', 'cors_restricted', 0),
	 is_default_host=>0
);

DB.DBA.URLREWRITE_CREATE_RULELIST (
'http_rule_list_1', 1,
vector ('datamodel_200_rule', 'datamodel_210_rule', 'datamodel_current', 'sparql_describe_for_known_formats', 'sparql_describe_for_ntriples', 'faceted_browsing'));

-- send back all request to the versioned datamodel url to apache (which will make content negociation)
DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
  'datamodel_200_rule', 
  1,
  '^/dbnary/2.0.0/*\$',
  vector (),
  0,
  '/static/datamodel/2.0.0',
  vector (),
  NULL,
  NULL,
  1,
  303,
  ''
);

-- send back all request to the versioned datamodel url to apache (which will make content negociation)
DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
  'datamodel_210_rule', 1,
  '^/dbnary/2.1.0/*\$',
  vector (),
  0,
  '/static/datamodel/2.1.0',
  vector (),
  NULL,
  NULL,
  1,
  303,
  ''
);

-- send back all request to the datamodel url to apache (which will make content negociation)
DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
  'datamodel_current', 1,
  '^/dbnary/*\$',
  vector (),
  0,
  '/static/datamodel/current/',
  vector (),
  NULL,
  NULL,
  1,
  303,
  ''
);

-- Send all request to dbanry IRI to SPARQL DESCRIBE for various response formats
DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
  'sparql_describe_for_known_formats', 1,
  '^/(.*)\$',
  vector ('par_1'),
  1,
  '/sparql?query=DESCRIBE%%20%%3Chttp%%3A%%2F%%2Fkaiko.getalp.org%%2F%U%%3E&format=%U',
  vector ('par_1', '*accept*'),
  NULL,
  '(text/rdf.n3)|(application/rdf.xml)|(text/n3)|(text/turtle)|(application/x-turtle)|(application/x-trig)|(application/ld.json)|(text/rdf.nt)|(text/csv)|(application/odata.json)|(application/microdata.json)|(application/rdf.json)|(application/x-json.ld)|(application/atom.xml)|(application/xhtml.xml)|(application/rdf.json)',
  2,
  303,
  ''
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'sparql_describe_for_ntriples', 1,
    '^/(.*)\$',
vector ('par_1'),
1,
  '/sparql?query=DESCRIBE%%20%%3Chttp%%3A%%2F%%2Fkaiko.getalp.org%%2F%U%%3E&format=text%%2Fplain',
vector ('par_1'),
NULL,
'(application/n-triple)|(text/plain)',
2,
303,
''
);

DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'faceted_browsing', 1,
'^/(.*)\$',
vector ('par_1'),
1,
'/describe/?url=http%%3A%%2F%%2Fkaiko.getalp.org%%2F%s',
vector ('par_1'),
NULL,
'(text/html)|(\\*/\\*)',
0,
303,
''
);

-- create redirections for dilaf

DB.DBA.VHOST_REMOVE ( lhost=>'*ini*', vhost=>'*ini*', lpath=>'/dilaf' );

DB.DBA.VHOST_DEFINE ( lhost=>'*ini*', vhost=>'*ini*', lpath=>'/dilaf', ppath=>'/DAV/', is_dav=>1,
def_page=>'', vsp_user=>'dba', ses_vars=>0, opts=>vector ('browse_sheet', '', 'url_rewrite', 'http_rule_list_2'),
is_default_host=>0
);

DB.DBA.URLREWRITE_CREATE_RULELIST (
'http_rule_list_2', 1,
vector ('http_rule_5', 'http_rule_6'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'http_rule_5', 1,
'^/(.*)\$',
vector ('par_1'),
1,
'/sparql?query=DESCRIBE%%20%%3Chttp%%3A%%2F%%2Fkaiko.getalp.org%%2F%U%%3E&format=%U',
vector ('par_1', '*accept*'),
NULL,
'(text/rdf.n3)|(application/rdf.xml)',
2,
303,
''
);


DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'http_rule_6', 1,
'^/(.*)\$',
vector ('par_1'),
1,
'/describe/?url=http%%3A%%2F%%2Fkaiko.getalp.org%%2F%s',
vector ('par_1'),
NULL,
'(text/html)|(\\*/\\*)',
0,
303,
''
);

-- create redirections for jdm

DB.DBA.VHOST_REMOVE ( lhost=>'*ini*', vhost=>'*ini*', lpath=>'/jdm' );

DB.DBA.VHOST_DEFINE ( lhost=>'*ini*', vhost=>'*ini*', lpath=>'/jdm', ppath=>'/DAV/', is_dav=>1,
def_page=>'', vsp_user=>'dba', ses_vars=>0, opts=>vector ('browse_sheet', '', 'url_rewrite', 'http_rule_list_3'),
is_default_host=>0
);

DB.DBA.URLREWRITE_CREATE_RULELIST (
'http_rule_list_3', 1,
vector ('http_rule_7', 'http_rule_8'));

DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'http_rule_7', 1,
'^/(.*)\$',
vector ('par_1'),
1,
'/sparql?query=DESCRIBE%%20%%3Chttp%%3A%%2F%%2Fkaiko.getalp.org%%2F%U%%3E&format=%U',
vector ('par_1', '*accept*'),
NULL,
'(text/rdf.n3)|(application/rdf.xml)',
2,
303,
''
);


DB.DBA.URLREWRITE_CREATE_REGEX_RULE (
'http_rule_8', 1,
'^/(.*)\$',
vector ('par_1'),
1,
'/describe/?url=http%%3A%%2F%%2Fkaiko.getalp.org%%2F%s',
vector ('par_1'),
NULL,
'(text/html)|(\\*/\\*)',
0,
303,
''
);

-- install sparql endpoint with allow all CORS (allows any web app to access the endpoint directly)
DB.DBA.VHOST_REMOVE (
  lhost=>'*sslini*',
  vhost=>'*sslini*',
  lpath=>'/sparql'
);

DB.DBA.VHOST_DEFINE (
  lhost=>'*sslini*',
  vhost=>'*sslini*',
  lpath=>'/sparql',
  ppath=>'/!sparql/',
  is_dav=>1,
  is_brws=>0,
  def_page=>'',
  sec=>'SSL',
  vsp_user=>'dba',
  ses_vars=>0,
  opts=>vector ('browse_sheet', '', 'noinherit', 'yes', 'cors', '*', 'cors_allow_headers', '', 'cors_restricted', 0),
  is_default_host=>0
);

DB.DBA.VHOST_REMOVE (
  lhost=>'*ini*',
  vhost=>'*ini*',
  lpath=>'/sparql'
);

DB.DBA.VHOST_DEFINE (
  lhost=>'*ini*',
  vhost=>'*ini*',
  lpath=>'/sparql',
  ppath=>'/!sparql/',
  is_dav=>1,
  is_brws=>0,
  def_page=>'',
  vsp_user=>'dba',
  ses_vars=>0,
  opts=>vector ('browse_sheet', '', 'noinherit', 'yes', 'cors', '*', 'cors_allow_headers', '', 'cors_restricted', 0),
  is_default_host=>0
);

-- Create namespaces for dbnary

DB.DBA.XML_SET_NS_DECL ('skos', 'http://www.w3.org/2004/02/skos/core#', 2);

DB.DBA.XML_SET_NS_DECL ('lexinfo', 'http://www.lexinfo.net/ontology/2.0/lexinfo#', 2);
DB.DBA.XML_SET_NS_DECL ('lexvo', 'http://lexvo.org/id/iso639-3/', 2);
DB.DBA.XML_SET_NS_DECL ('dcterms', 'http://purl.org/dc/terms/', 2);
DB.DBA.XML_SET_NS_DECL ('lemon', 'http://lemon-model.net/lemon#', 2);
DB.DBA.XML_SET_NS_DECL ('ontolex', 'http://www.w3.org/ns/lemon/ontolex#', 2);
DB.DBA.XML_SET_NS_DECL ('vartrans', 'http://www.w3.org/ns/lemon/vartrans#', 2);
DB.DBA.XML_SET_NS_DECL ('lime', 'http://www.w3.org/ns/lemon/lime#', 2);
DB.DBA.XML_SET_NS_DECL ('synsem', 'http://www.w3.org/ns/lemon/synsem#', 2);
DB.DBA.XML_SET_NS_DECL ('decomp', 'http://www.w3.org/ns/lemon/decomp#', 2);
DB.DBA.XML_SET_NS_DECL ('olia', 'http://purl.org/olia/olia.owl#', 2);
DB.DBA.XML_SET_NS_DECL ('qb', 'http://purl.org/linked-data/cube#', 2);

DB.DBA.XML_SET_NS_DECL ('dbnary', 'http://kaiko.getalp.org/dbnary#', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-bul', 'http://kaiko.getalp.org/dbnary/bul/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-deu', 'http://kaiko.getalp.org/dbnary/deu/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-ell', 'http://kaiko.getalp.org/dbnary/ell/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-eng', 'http://kaiko.getalp.org/dbnary/eng/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-fin', 'http://kaiko.getalp.org/dbnary/fin/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-fra', 'http://kaiko.getalp.org/dbnary/fra/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-ind', 'http://kaiko.getalp.org/dbnary/ind/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-ita', 'http://kaiko.getalp.org/dbnary/ita/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-jpn', 'http://kaiko.getalp.org/dbnary/jpn/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-lat', 'http://kaiko.getalp.org/dbnary/lat/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-lit', 'http://kaiko.getalp.org/dbnary/lit/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-mlg', 'http://kaiko.getalp.org/dbnary/mlg/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-nld', 'http://kaiko.getalp.org/dbnary/nld/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-nor', 'http://kaiko.getalp.org/dbnary/nor/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-pol', 'http://kaiko.getalp.org/dbnary/pol/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-por', 'http://kaiko.getalp.org/dbnary/por/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-rus', 'http://kaiko.getalp.org/dbnary/rus/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-shr', 'http://kaiko.getalp.org/dbnary/shr/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-spa', 'http://kaiko.getalp.org/dbnary/spa/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-swe', 'http://kaiko.getalp.org/dbnary/swe/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-tur', 'http://kaiko.getalp.org/dbnary/tur/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-kur', 'http://kaiko.getalp.org/dbnary/kur/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnary-zho', 'http://kaiko.getalp.org/dbnary/zho/', 2);
DB.DBA.XML_SET_NS_DECL ('dilaf-bam', 'http://kaiko.getalp.org/dilaf/bam/', 2);
DB.DBA.XML_SET_NS_DECL ('jdm-ont', 'http://kaiko.getalp.org/jdm#', 2);
DB.DBA.XML_SET_NS_DECL ('jdm', 'http://kaiko.getalp.org/jdm/', 2);
DB.DBA.XML_SET_NS_DECL ('dbnstats', 'http://kaiko.getalp.org/dbnary/statistics/', 2);

-- Allow for federated queries through DBnary end point
GRANT "SPARQL_LOAD_SERVICE_DATA" to "SPARQL";
-- GRANT "SPARQL_SPONGE" to "SPARQL";
REVOKE "SPARQL_SPONGE" to "SPARQL";
GRANT "SPARQL_SELECT_FED" TO "SPARQL";
-- Temporary fix for virtuoso bug #1094
DB.DBA.RDF_DEFAULT_USER_PERMS_SET ('nobody', 7);

checkpoint;
-- Load Core ontologies
SPARQL LOAD <http://www.lexinfo.net/ontology/2.0/lexinfo#> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://purl.org/dc/terms/> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://lemon-model.net/lemon> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://www.w3.org/ns/lemon/ontolex> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://www.w3.org/ns/lemon/vartrans> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://www.w3.org/ns/lemon/lime> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://www.w3.org/ns/lemon/synsem> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://www.w3.org/ns/lemon/decomp> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://purl.org/olia/olia.owl> into graph <http://kaiko.getalp.org/datamodel>;
SPARQL LOAD <http://purl.org/linked-data/cube> into graph <http://kaiko.getalp.org/datamodel>;
-- Load dbnary ontology from latest version (be sure to deploy the latest version to the public server before rotating)
SPARQL LOAD <http://kaiko.getalp.org/dbnary> into graph <http://kaiko.getalp.org/datamodel>;

commit WORK;
checkpoint;

