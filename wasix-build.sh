#! /bin/bash

set -exuo pipefail

for dir in . psycopg psycopg_binary psycopg_c psycopg_pool; do
  rm -rf $dir/build $dir/dist $dir/*.egg-info
done

source .cross-venv/bin/activate

python3 -m build psycopg_pool --wheel --outdir dist --no-isolation