#!/usr/bin/env bash

set -xeuo pipefail

rm -rf dist

mkdir dist

cp package.json README.md LICENSE dist/

jq 'del(.devDependencies, .scripts)' < package.json > dist/package.json

cp -r contracts/* dist/

cd dist/

npm publish --access public