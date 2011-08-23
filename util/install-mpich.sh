#!/bin/bash -e
pwd="${PWD}"
cd "${1:-.}"
prefix="${PWD}"

# MPICH2
url="http://www.mcs.anl.gov/research/projects/mpich2/downloads/tarballs/1.4/mpich2-1.4.tar.gz"
tag=$( basename "$url" .tar.gz )
cd "${prefix}"
curl -L "${url}" | tar zx
cd "${tag}"
./configure -prefix="${prefix}"
make
make install
export PATH="${prefix}/bin:${PATH}"

cd "${pwd}"

