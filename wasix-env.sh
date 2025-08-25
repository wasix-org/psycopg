#! /bin/bash

set -exuo pipefail

rm -rf .native-venv .cross-venv

python3.13 -m venv ./.native-venv
source ./.native-venv/bin/activate
pip install crossenv

python -m crossenv ../cpython-install/cpython/bin/python3.wasm ./.cross-venv --cc wasixcc
source .cross-venv/bin/activate
build-pip install "cython<3.1.0,>=3.0.0" build setuptools wheel
