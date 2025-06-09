#! /bin/bash

set -exuo pipefail

for dir in . psycopg psycopg_c psycopg_pool; do
  rm -rf $dir/build $dir/dist $dir/*.egg-info
done

source .cross-venv/bin/activate

export WASIXCC_SYSROOT=/home/arshia/repos/wasmer/wasix-libc/sysroot32-ehpic/
export WASIXCC_COMPILER_FLAGS=-Wno-unreachable-code-fallthrough:-D__linux__
export WASIXCC_WASM_EXCEPTIONS=yes
export WASIXCC_PIC=yes
export PG_INCLUDE_DIR=$(pwd)/../python-wasix-binaries/pgsql/include
export PG_LIB_DIR=$(pwd)/../python-wasix-binaries/pgsql/lib
python3 -m build psycopg_c --wheel --outdir dist
python3 -m build psycopg_pool --wheel --outdir dist
python3 -m build psycopg --wheel --outdir dist
