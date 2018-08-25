#!/usr/bin/env bash

DIRECTORIES=("dotnet/fsharp" "jvm/clojure" "jvm/scala" "nodejs/clojurescript" "nodejs/bucklescript" "nodejs/purescript" "shims/haskell")
NUMBERS=(10 100 1000 10000 100000 250000 500000 750000 1000000)

pushd ../aws 2>&1 >/dev/null

echo "language,platform,number,memory,allocated_memory"

for DIR in "${DIRECTORIES[@]}"; do
  pushd "${DIR}" 2>&1 >/dev/null

  LANGUAGE=`echo "${DIR}" | cut -d'/' -f2`
  PLATFORM=`echo "${DIR}" | cut -d'/' -f1`
  ALLOCATED_MEMORY=256

  RESULT=`sls info`
  URL=`echo "${RESULT}" | grep "/dev/sieve" | cut -d" " -f5`

  for N in "${NUMBERS[@]}"; do
    curl -XPOST -s -o /dev/null "${URL}?number=${N}"
    sleep 5
  done

  sleep 20

  STREAM="/aws/lambda/fp-sls-aws-${PLATFORM}-${LANGUAGE}-dev-sieve"

  if [[ "${LANGUAGE}" == "clojure" ]]; then
    STREAM="/aws/lambda/fp-sls-aws-${PLATFORM}-clj-dev-sieve"
  elif [[ "${LANGUAGE}" == "clojurescript" ]]; then
    STREAM="/aws/lambda/fp-sls-aws-${PLATFORM}-cljs-dev-sieve"
  fi

  I=0
  for MEMORY in $(cwtail -p private ${STREAM} | awk '/Memory Used:/ { print $18 }'); do
    echo "${LANGUAGE},${PLATFORM},${NUMBERS[${I}]},${MEMORY},${ALLOCATED_MEMORY}"
    I=$((I + 1))
  done

  popd 2>&1 >/dev/null
done

popd 2>&1 >/dev/null
