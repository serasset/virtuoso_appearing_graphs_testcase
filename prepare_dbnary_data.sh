#!/bin/bash
DEFAULT_RAW_DATA_DIR=./data
RAW_DATA_DIR=${RAW_DATA_DIR:-${DEFAULT_RAW_DATA_DIR}}

# to use smaller datasets, set the env variable DBNARY_LANGUAGES to a subset of all languages
DBNARY_ALL_LANGUAGES="fr en de pt it fi ru el tr ja es bg pl nl sh sv lt no mg id la ku zh ga ca"
DBNARY_LANGUAGES=${DBNARY_LANGUAGES:-${DBNARY_ALL_LANGUAGES}}

# to further reduce the datasets, set DBNARY_MODELS to a subset of the models
DBNARY_ALL_MODELS="ontolex morphology enhancements exolex_ontolex exolex_morphology"
DBNARY_MODELS=${DBNARY_MODELS:-${DBNARY_ALL_MODELS}}

if [[ ! -d $RAW_DATA_DIR ]]
then
  mkdir -p $RAW_DATA_DIR
  pushd $RAW_DATA_DIR
  for l in $DBNARY_LANGUAGES
  do
    for m in $DBNARY_MODELS
    do
      wget http://kaiko.getalp.org/static/ontolex/latest/${l}_dbnary_${m}.ttl.bz2
    done
  done
  popd
else
    echo $RAW_DATA_DIR already exist, exiting...
fi
