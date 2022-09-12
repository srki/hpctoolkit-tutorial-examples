#!/bin/bash

date > .build_begin

$HPCTOOLKIT_MINIQMC_MODULES_BUILD

rm -rf miniqmc

MPI_ROOT=ignore
CUDA_HOME=ignore

if [[ ! -z "$CUDAPATH" ]] 
then
    export CUDA_HOME=$CUDAPATH
fi


if [[ ! -z "$MPI_ROOT" ]] 
then
    export MPI_HOME=$MPI_ROOT
fi

if [[ -z "$CUDA_HOME" ]] 
then
    echo CUDA_HOME must be set
    exit
fi

if [[ -z "$MPI_HOME" ]] 
then
    echo MPI_HOME must be set
    exit
fi


if [[ -z "`type -p cmake`" ]] 
then
    echo "CMake version 3.21 or newer was not found in your PATH"
    exit
fi

echo using CUDA_HOME=$CUDA_HOME
echo using MPI_HOME=$MPI_HOME

export CMAKE_MAJOR_VERSION=`cmake --version | head -1 | tr '.' ' ' | awk '{print $3}'`
export CMAKE_MINOR_VERSION=`cmake --version | head -1 | tr '.' ' ' | awk '{print $4}'`

echo using cmake $CMAKE_MAJOR_VERSION.$CMAKE_MINOR_VERSION

if (( $CMAKE_MAJOR_VERSION < 3 )) 
then
 echo "CMake version 3.21 or newer was not found in your PATH"
 exit
else
   if (( $CMAKE_MAJOR_VERSION == 3 )) 
   then 
      if (( $CMAKE_MINOR_VERSION < 21 ))
      then
         echo "CMake version 3.21 or newer was not found in your PATH"
         exit
      fi
    fi
fi


# miniqmc
git clone https://github.com/QMCPACK/miniqmc.git
pushd miniqmc
git checkout OMP_offload
popd
mkdir miniqmc/miniqmc-build
pushd miniqmc/miniqmc-build
# cmake -DCMAKE_CXX_COMPILER=mpicxx -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_LDFLAGS=-lessl ..
cmake -DCMAKE_CXX_COMPILER=$HPCTOOLKIT_MINIQMC_CXX_COMPILER -DCMAKE_BUILD_TYPE=RelWithDebInfo $HPCTOOLKIT_MINIQMC_GPUFLAGS ..
make -j VERBOSE=1

date > .build_end
