#! /bin/bash

set -exuo pipefail

for dir in . psycopg psycopg_binary psycopg_c psycopg_pool; do
  rm -rf $dir/build $dir/dist $dir/*.egg-info
done

source .cross-venv/bin/activate

if [ ! -d psycopg_binary ]; then
  python3 ./tools/build/copy_to_binary.py
fi

DEPS_DIR=$(realpath ../python-wasix-binaries)

export WASIXCC_COMPILER_FLAGS=-Wno-unreachable-code-fallthrough:-D__linux__
export WASIXCC_LINKER_FLAGS="-L$DEPS_DIR/pgsql/lib:-lpq:-rpath=\$ORIGIN"
export WASIXCC_WASM_EXCEPTIONS=yes
export WASIXCC_PIC=yes
export PG_INCLUDE_DIR=$DEPS_DIR/pgsql/include
export PG_LIB_DIR=$DEPS_DIR/pgsql/lib
python3 -m build psycopg_c --wheel --outdir dist --no-isolation
python3 -m build psycopg_binary --wheel --outdir dist --no-isolation
python3 -m build psycopg --wheel --outdir dist --no-isolation

# Embed libpq into the binary packages, so it can be loaded automatically
# via the $ORIGIN RUNPATH specified above.
cd dist

rm -rf temp
mkdir temp
unzip psycopg_binary-3.2.9-cp313-cp313-wasix_wasm32.whl -d temp
cp -L $DEPS_DIR/pgsql/lib/libpq.so temp/psycopg_binary/
rm psycopg_binary-3.2.9-cp313-cp313-wasix_wasm32.whl
cd temp
zip -r ../psycopg_binary-3.2.9-cp313-cp313-wasix_wasm32.whl *
cd ..

rm -rf temp
mkdir temp
unzip psycopg_c-3.2.9-cp313-cp313-wasix_wasm32.whl -d temp
cp -L $DEPS_DIR/pgsql/lib/libpq.so temp/psycopg_c/
rm psycopg_c-3.2.9-cp313-cp313-wasix_wasm32.whl
cd temp
zip -r ../psycopg_c-3.2.9-cp313-cp313-wasix_wasm32.whl *
cd ..

rm -rf temp