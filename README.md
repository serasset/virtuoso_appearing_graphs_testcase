How to reproduce the bug
========================

1. clone the repo + cd in repo's dir
2. Prepare the RAW DBNARY DATA to be uploaded in your virtuoso instance:
  ```bash
export DBNARY_LANGUAGES="fr en de pt it fi ru el tr ja es bg pl nl sh sv lt no mg id la ku zh ga ca"
export DBNARY_MODELS="ontolex morphology enhancements exolex_ontolex exolex_morphology"
./prepare_dbnary_data.sh
```
You may remove some language and models to reduce the DB size and loading time... but if you later want to increase the number of language fetch all of them (you'll be able to reduce the number effectivemy loaded)

3. start the virtuoso server with docker:
```bash
./start.sh
```

Your http server will be bound to port 8998 (so that it won't conflict with an eventual existing server), to ease debugging, you can bind the 8998 port to 8890 on your client machine using ssh.

4. Check the number of graphs
```bash
isql localhost:2222 dba
```
then
```sql
SPARQL SELECT ?g WHERE { GRAPH ?g { ?s ?p ?o } } GROUP BY ?g ORDER BY ?g;
```

   
5. put some pressure to the server by replaying real http connection received in deployment
```bash
./replay.sh
## Or, i you want to put more pressure...
./replay.sh & ./replay.sh & ./replay.sh & ./replay.sh &
```

6. Check the number of graphs (with the same sparql query)
   
Note the bug is not deterministic, so sometime you may have to stress a little bit more the server by iterating the replay several times in parallel (but I noticed an erroneous graph appearing even with only one replay process. 

 



