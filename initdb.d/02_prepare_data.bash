shopt -s nullglob

# to use smaller datasets, set the env variable DBNARY_LANGUAGES to a subset of all languages
DBNARY_ALL_LANGUAGES="fr en de pt it fi ru el tr ja es bg pl nl sh sv lt no mg id la ku zh ga ca"
DBNARY_LANGUAGES=${DBNARY_LANGUAGES:-${DBNARY_ALL_LANGUAGES}}

# to further reduce the datasets, set DBNARY_MODELS to a subset of the models
DBNARY_ALL_MODELS="ontolex morphology enhancements exolex_ontolex exolex_morphology"
DBNARY_MODELS=${DBNARY_MODELS:-${DBNARY_ALL_MODELS}}



# Prepare the dataset directory
## Converting language codes
declare -A iso3Lang
iso3Lang[bg]="bul"
iso3Lang[de]="deu"
iso3Lang[el]="ell"
iso3Lang[en]="eng"
iso3Lang[es]="spa"
iso3Lang[fi]="fin"
iso3Lang[fr]="fra"
iso3Lang[it]="ita"
iso3Lang[ja]="jpn"
iso3Lang[pl]="pol"
iso3Lang[pt]="por"
iso3Lang[ru]="rus"
iso3Lang[tr]="tur"
iso3Lang[nl]="nld"
iso3Lang[sh]="shr"
iso3Lang[sv]="swe"
iso3Lang[lt]="lit"
iso3Lang[id]="ind"
iso3Lang[la]="lat"
iso3Lang[mg]="mlg"
iso3Lang[no]="nor"
iso3Lang[bm]="bam"
iso3Lang[ku]="kur"
iso3Lang[zh]="zho"
iso3Lang[ca]="cat"
iso3Lang[ga]="gle"


DATASETDIR="dataset"
mkdir -p ${DATASETDIR}
pushd ${DATASETDIR}

if [[ -d /data ]]
then
  for l in $DBNARY_LANGUAGES
  do
    for m in $DBNARY_MODELS
    do
      ln -s /data/${l}_dbnary_${m}.ttl.bz2 .
    done
  done
  popd
else
    echo /data does not exist, database will be empty...
fi

popd


## create the .graph files for all files in ${DATASETDIR}
langRegex2='(..)_([^_]*)_(.*)'
langRegex3='(...)_([^_]*)_(.*)'
statsRegex2='(..)_(.*)_statistics(.*)'
exolexRegex2='(..)_([^_]*)_exolex_(.*)'
for f in $DATASETDIR/*.ttl{.bz2,.gz,.xz,}; do
  f=${f%.bz2}
  f=${f%.gz}
  f=${f%.xz}
  if [[ $f =~ $statsRegex2 ]]; then
    lg2=${BASH_REMATCH[1]}
    echo "http://kaiko.getalp.org/statistics" >"$f.graph"
  elif [[ $f =~ $exolexRegex2 ]]; then
    lg2=${BASH_REMATCH[1]}
    graph=${BASH_REMATCH[2]}
    lg3=${iso3Lang[$lg2]}
    echo "http://kaiko.getalp.org/$graph/${lg3}_exolex" >"$f.graph"
  elif [[ $f =~ $langRegex2 ]]; then
    lg2=${BASH_REMATCH[1]}
    graph=${BASH_REMATCH[2]}
    lg3=${iso3Lang[$lg2]}
    echo "http://kaiko.getalp.org/$graph/$lg3" >"$f.graph"
  elif [[ $f =~ $langRegex3 ]]; then
    lg3=${BASH_REMATCH[1]}
    graph=${BASH_REMATCH[2]}
    echo "http://kaiko.getalp.org/$graph/$lg3" >"$f.graph"
  fi
done
