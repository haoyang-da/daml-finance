#!/usr/bin/env bash
# Copyright (c) 2023 Digital Asset (Switzerland) GmbH and/or its affiliates. All rights reserved.
# SPDX-License-Identifier: Apache-2.0

set -eu

# Use absolute paths to allow this script to be called from any location
script_dir=$(cd "$(dirname $0)"; pwd -P)
docs_dir=$(cd ${script_dir}; cd ..; pwd -P)
root_dir=$(cd ${docs_dir}; cd ..; pwd -P)

# Remove any existing .assembly/ directories from docs
if [[ -d ${docs_dir}/.assembly ]]; then
  rm -rf ${docs_dir}/.assembly
fi
mkdir ${docs_dir}/.assembly

# Copy source code into assembly file structure
cp -r ${root_dir}/src ${docs_dir}/.assembly

# Copy doc build output into assembly file structure
mkdir -p ${docs_dir}/.assembly/reference/code-documentation
cp -r ${docs_dir}/build/daml-finance-rst ${docs_dir}/.assembly/reference/code-documentation/daml-finance-rst
cp ${docs_dir}/build/daml-finance-hoogle.txt ${docs_dir}/.assembly/reference/daml-finance-hoogle.txt

# Update the directory paths in the RST files as per the assembly structure
find ${docs_dir}/.assembly -type f -name '*.rst' -print0 | while IFS= read -r -d '' file
do
    sed -i 's|.. literalinclude:: ../../|.. literalinclude:: |g' $file
done
