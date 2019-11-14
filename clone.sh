#!/usr/bin/env bash

set -euox pipefail

rm -rf out/target
rm -rf out/source

mkdir -p out

pushd out

git clone git@ssh.dev.azure.com:v3/wcorn/infra/bootstrap source
git clone git@ssh.dev.azure.com:v3/wcorn/manifests/argocd-bootstrap target

popd
