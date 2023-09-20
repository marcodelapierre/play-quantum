#!/bin/bash

# has to be run from the quantum-play repo, subdir install_scripts/topaz/

py_ver="3.10.10"
pip_ver="23.1.2"
st_ver="68.0.0"

module load maali/1.8.4
mkdir -p $MYGROUP/software/centos7.6/modulefiles
module use $MYGROUP/software/centos7.6/modulefiles

sed -i "s;\"setuptools/.*\";\"setuptools/$st_ver\";g" pip.cyg

maali -t Python -v $py_ver
export MAALI_DEFAULT_PYTHON=python/$py_ver

maali -t setuptools -v $st_ver
maali -t pip -v $pip_ver
