#!/usr/bin/env bash

set -euox pipefail

MAJOR=$(<version/major tr -d '\r')
MINOR=$(<version/minor tr -d '\r')
PATCH=$(<version/patch tr -d '\r')

METADATA=$(date +'+%Y%m%d_%H%M%SZ')

RELEASE="${MAJOR}.${MINOR}.${PATCH}"
BUILD="${MAJOR}.${MINOR}.${PATCH}-${METADATA}"

pushd out/source
git add version/* ||:
git commit -m $RELEASE ||:
git tag -a $BUILD -m $BUILD ||:
popd

pushd out/target
git add . ||:
git commit -m $RELEASE ||:
git tag -a $BUILD -m $BUILD ||:

git push origin ||:
git push origin $BUILD ||:

popd
pushd out/source
git push origin ||:
git push origin $BUILD ||:
