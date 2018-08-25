#!/usr/bin/env bash

DIRECTORIES=("dotnet/fsharp" "jvm/clojure" "jvm/scala" "nodejs/clojurescript" "nodejs/bucklescript" "nodejs/purescript" "shims/haskell")

pushd aws 2>&1 >/dev/null

for DIR in "${DIRECTORIES[@]}"; do
  pushd "${DIR}" 2>&1 >/dev/null

  sls remove

  popd 2>&1 >/dev/null
done

popd 2>&1 >/dev/null